import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lev_mobile/widgets/form_field.dart';

class PasswordStep extends StatefulWidget {
  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  PasswordStep({
    Key? key,
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController
  }) : super(key: key);

  @override
  State<PasswordStep> createState() => _PasswordStepState();
}

class _PasswordStepState extends State<PasswordStep> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          SizedBox(height: 10),
          CustomFormField(
            hintText: "Mot de Passe",
            icon: IconlyLight.lock,
            isPassword: true,
            controller: widget.passwordController,
          ),
          CustomFormField(
            hintText: "Confirmation Mot de Passe",
            icon: IconlyLight.lock,
            isPassword: true,
            controller: widget.confirmPasswordController,
            marginBottom: 0,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
