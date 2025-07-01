import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garbageClassification/common/util/Payment/payment_config.dart';
import 'package:pay/pay.dart';

class Googlepay extends StatefulWidget {
  const Googlepay({super.key});

  @override
  State<Googlepay> createState() => _GooglepayState();
}

class _GooglepayState extends State<Googlepay> {
  bool isScanButtonEnabled = false; // Thêm state để quản lý trạng thái nút scan

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
        'money': 30,
        'createdAt': DateTime.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GooglePayButton(
      paymentConfiguration: PaymentConfiguration.fromJsonString(
        defaultGooglePay,
      ),
      paymentItems: const [
        PaymentItem(
          label: 'Mở khóa tính năng nhận diện rác',
          amount: '30',
          status: PaymentItemStatus.final_price,
        ),
      ],
      type: GooglePayButtonType.pay,
      margin: const EdgeInsets.only(top: 15.0),
      width: 350,
      onPaymentResult: (result) {
        if (result['paymentMethodData'] != null) {
          _updateProfile();
          _listmoney();
          setState(() => isScanButtonEnabled = true); // Sử dụng setState hợp lệ
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
}