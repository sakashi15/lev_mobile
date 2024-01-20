import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OtpStep extends StatefulWidget {
  dynamic onCompleted;
  GlobalKey formKey = GlobalKey<FormState>();
  OtpStep({
    Key? key,
    required this.onCompleted,
    required this.formKey,
  }) : super(key: key);

  @override
  State<OtpStep> createState() => _OtpStepState();
}

class _OtpStepState extends State<OtpStep> {

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          SizedBox(height: 18),
          Text(
            "Veuillez entrer le code OTP envoyé à votre email pour activer votre compte.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          OTPTextField(
            length: 6,
            width: MediaQuery.of(context).size.width,
            fieldWidth: 20,
            style: TextStyle(
                fontSize: 14
            ),
            textFieldAlignment: MainAxisAlignment.spaceAround,
            fieldStyle: FieldStyle.underline,
            onCompleted: widget.onCompleted,
          ),
          SizedBox(height: 18),
        ],
      ),
    );
  }

}
