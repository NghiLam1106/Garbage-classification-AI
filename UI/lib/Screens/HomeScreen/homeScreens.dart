// ignore_for_file: unused_import, file_names, use_build_context_synchronously

import 'dart:convert';
// ignore: unnecessary_import
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:garbageClassification/Screens/GuideScreen/GuideScreen.dart';
import 'package:garbageClassification/Screens/HomeScreen/widget/buildBtn.dart';
import 'package:garbageClassification/Screens/GameScreen/MyPlantsScreen.dart';
import 'package:garbageClassification/Screens/PlantIssuesScreen/PlantIssuesScreen.dart';
import 'package:garbageClassification/router/app_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
        });
        await _analyzeImageWeb(bytes);
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        await _analyzeImage(_imageFile!);
      }
    }
  }

  void handleMessage() {
    // ignore: avoid_print
    print("Mở tin nhắn...");
  }

 /* Future<void> _handlePayment() async {
    final payUrl = await MomoService.createMomoPayment("1000");

    if (payUrl != null) {
      if (await canLaunchUrl(Uri.parse(payUrl))) {
        await launchUrl(
          Uri.parse(payUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        // ignore: avoid_print
        print("Không thể mở URL: $payUrl");
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Không thể tạo thanh toán")));
    }
  }*/

  Future<void> _analyzeImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:8000/api/plant/'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );
    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var jsonData = json.decode(responseData);

    setState(() {
      _result = jsonData['disease'] ?? 'Không xác định';
    });
  }

  Future<void> _analyzeImageWeb(Uint8List imageBytes) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:8000/api/plant/'),
    );

    request.files.add(
      http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'),
    );
    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var jsonData = json.decode(responseData);

    setState(() {
      _result = jsonData['disease'] ?? 'Không xác định';
      isChatIcon = !isChatIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_currentIndex == 3) {
      body = GuideScreen();
    } else if (_currentIndex == 2) {
      body = GuideScreen();
    } else if (_currentIndex == 1) {
      body = MyPlantsScreen();
    } else {
      body = Stack(
        children: [
          Positioned.fill(
            child: Image.asset('images/bg9.png', fit: BoxFit.cover),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () {
                if (isChatIcon) {
                  handleMessage();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isChatIcon ? Icons.message : Icons.attach_money,
                  color: Colors.green,
                  size: 28,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Xác định một căn bệnh trong 1 cú nhấp chuột',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              buildButton('Quét cây trồng', _pickImage),
              const SizedBox(height: 10),
              buildButton('Những vấn đề chung', () {
                Navigator.pushReplacementNamed(context, AppRouter.plIs);
              }),
              const SizedBox(height: 10),
              buildButton('Hỏi đáp về cây trồng 💬', () {
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
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm cây'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist),
            label: 'Cây của tôi',
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
}
