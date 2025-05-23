// ignore_for_file: unused_import, file_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:garbageClassification/Screens/ChatBotScreen/chatScreen.dart';
import 'package:garbageClassification/Screens/GameScreen/GameScreen.dart';
import 'package:garbageClassification/Screens/GuideScreen/GuideScreen.dart';
import 'package:garbageClassification/Screens/HomeScreen/widget/buildBtn.dart';
import 'package:garbageClassification/Screens/Payment/payment_config.dart';
import 'package:garbageClassification/Screens/ProfileScreen/profileScreens.dart';
import 'package:garbageClassification/auth/auth.dart';
import 'package:garbageClassification/router/app_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pay/pay.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _imageFile;
  Uint8List? _imageBytes;
  String _result = "";
  int _currentIndex = 0;
  bool isChatIcon = false;
  bool isScanButtonEnabled = false;
  bool isPaymentInitiated = false;
  @override
  void initState() {
    super.initState();
    _checkPlanUnlocked();
    _check();
  }

  void _check() async {
    final auth = AuthController();
    final user = await auth.getUserData();

    if (user != null && user.role == 'admin') {
      Navigator.pushReplacementNamed(
        context,
        AppRouter.admin,
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        final fileName = pickedFile.name;
        setState(() {
          _imageBytes = bytes;
        });
        await _analyzeImageWeb(bytes, fileName);
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        await _analyzeImage(_imageFile!);
      }
    }
  }

  Future<void> _analyzeImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:5000/predict'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );
    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var jsonData = json.decode(responseData);

    setState(() {
      _result = jsonData['predicted_class'] ?? 'Không xác định';
    });
  }

  Future<void> _analyzeImageWeb(Uint8List imageBytes, fileName) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:5000/predict'),
    );

    request.files.add(
      http.MultipartFile.fromBytes('file', imageBytes, filename: fileName),
    );
    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var jsonData = json.decode(responseData);

    setState(() {
      _result = jsonData['predicted_class'] ?? 'Không xác định';
      isChatIcon = !isChatIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_currentIndex == 3) {
      body = ProfileScreen();
    } else if (_currentIndex == 2) {
      body = GuideScreen();
    } else if (_currentIndex == 1) {
      body = GameScreen();
    } else {
      body = Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/bg13.png', fit: BoxFit.cover),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Phân rác đúng cách – Bé nhỏ làm điều to!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildPlanPageWithLock(),
              const SizedBox(height: 20),
              buildButton(
                'Quét rác thải',
                isScanButtonEnabled
                    ? () => _pickImage()
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Bạn chưa thanh toán chức năng này.'),
                          ),
                        );
                      },
              ),
              const SizedBox(height: 10),
              buildButton('Hỏi đáp về cách phân loại 💬', () {
                Navigator.pushNamed(context, AppRouter.chat);
              }),
              const SizedBox(height: 20),
              if (_imageBytes != null && kIsWeb)
                Image.memory(_imageBytes!, height: 200)
              else if (_imageFile != null)
                Image.file(_imageFile!, height: 200),
              const SizedBox(height: 10),
              Text(
                _result.isNotEmpty ? _result : 'Kết quả sẽ hiển thị ở đây',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            label: 'Trò chơi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Hướng dẫn'),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'Người dùng',
          ),
        ],
      ),
    );
  }

  Widget _buildApplePay() {
    return ApplePayButton(
      paymentConfiguration: PaymentConfiguration.fromJsonString(
        defaultApplePay,
      ),
      paymentItems: const [
        PaymentItem(
          label: 'Mở khóa tính năng nhận diện rác',
          amount: '30000',
          status: PaymentItemStatus.final_price,
        ),
      ],
      style: ApplePayButtonStyle.black,
      width: 250,
      height: 50,
      type: ApplePayButtonType.buy,
      margin: const EdgeInsets.only(top: 15.0),
      onPaymentResult: (result) {
        debugPrint('ApplePay Success: $result');
        setState(() => isScanButtonEnabled = true);
      },
      loadingIndicator: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildGooglePay() {
    print("Đang xử lý thanh toán Google Pay...");
    return GooglePayButton(
      paymentConfiguration: PaymentConfiguration.fromJsonString(
        defaultGooglePay,
      ),
      paymentItems: const [
        PaymentItem(
          label: 'Mở khóa tính năng nhận diện rác',
          amount: '30000',
          status: PaymentItemStatus.final_price,
        ),
      ],
      type: GooglePayButtonType.pay,
      margin: const EdgeInsets.only(top: 15.0),
      onPaymentResult: (result) {
        if (result['paymentMethodData'] != null) {
          _updateProfile();
          _listmoney();
          setState(() => isScanButtonEnabled = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thanh Toán Thành Công.'),
            ),
          );
          debugPrint('GooglePay Success: $result');
        }
      },
      loadingIndicator: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildPlanPageWithLock() {
    if (isScanButtonEnabled)
      return const SizedBox(); // Đã mở khóa → không hiển thị

    return SizedBox(
      width: double.infinity,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Chức năng quét rác đang bị khóa 🔒",
                style: TextStyle(
                    color: Color.fromARGB(253, 250, 0, 0), fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25, vertical: 20), // Tăng padding
                  elevation: 2,
                ),
                onPressed: () {
                  isPaymentInitiated = false;
                },
                child: const Text(
                  "Mở khóa chức năng quét rác thải",
                  style: TextStyle(
                    color: Color.fromARGB(255, 7, 140, 27),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (isPaymentInitiated == false)
                Platform.isIOS ? _buildApplePay() : _buildGooglePay(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'payment': "1"});
    }
  }

  Future<void> _listmoney() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('totalmoney').add({
        'uid': user.uid,
        'money': 30000,
        'createdAt': DateTime.now(),
      });
    }
  }

  Future<void> _checkPlanUnlocked() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data();
      print("Datacc: $data");
      if (data != null && data['payment'] == "1") {
        print("check");
        setState(() => isScanButtonEnabled = true);
      } else {
        print("No pay");
        setState(() => isScanButtonEnabled = false);
      }
    }
  }
}
