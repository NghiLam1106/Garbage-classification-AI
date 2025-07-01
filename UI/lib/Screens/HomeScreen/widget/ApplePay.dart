import 'package:flutter/material.dart';
import 'package:garbageClassification/common/util/Payment/payment_config.dart';
import 'package:pay/pay.dart';

class Applepay extends StatefulWidget {
  const Applepay({super.key, required this.handlePaymentResult});

  final Function(Map<String, dynamic>)? handlePaymentResult;

  @override
  State<Applepay> createState() => _ApplepayState();
}

class _ApplepayState extends State<Applepay> {
  @override
  Widget build(BuildContext context) {
    return ApplePayButton(
      paymentConfiguration: PaymentConfiguration.fromJsonString(
        defaultApplePay,
      ),
      paymentItems: const [
        PaymentItem(
          label: 'Mở khóa tính năng nhận diện rác',
          amount: '30',
          status: PaymentItemStatus.final_price,
        ),
      ],
      style: ApplePayButtonStyle.black,
      width: 250,
      height: 50,
      type: ApplePayButtonType.buy,
      margin: EdgeInsets.only(top: 15.0),
      onPaymentResult: widget.handlePaymentResult,
      loadingIndicator: const Center(child: CircularProgressIndicator()),
    );
  }
}