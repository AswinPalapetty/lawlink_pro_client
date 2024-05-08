import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPayment extends StatefulWidget {
  final String description, email, phone;

  const RazorpayPayment({super.key, required this.description, required this.email, required this.phone});

  @override
  State<RazorpayPayment> createState() => _RazorpayPaymentState();
}

class _RazorpayPaymentState extends State<RazorpayPayment> {
  late Razorpay _razorpay;
  late Map<String, dynamic> options;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    options = {
      'key': 'rzp_test_hRuJXY7QtiyiLU',
      'amount': 50000, //in the smallest currency sub-unit.
      'name': 'Acme Corp.',
      'description': widget.description,
      'timeout': 60, // in seconds
      'prefill': {
        'contact': widget.phone,
        'email': widget.email
      }
    };
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(), // Replace Container with your actual UI
    );
  }
}
