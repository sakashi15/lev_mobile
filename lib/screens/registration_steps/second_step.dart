import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lev_mobile/widgets/form_field.dart';

class AccountStep extends StatefulWidget {
  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  AccountStep({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController
  }) : super(key: key);

  @override
  State<AccountStep> createState() => _AccountStepState();
}

class _AccountStepState extends State<AccountStep> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          SizedBox(height: 10),
          CustomFormField(
            hintText: "Email",
            icon: IconlyLight.message,
            controller: widget.emailController,
            type: CustomFormFieldTypes.email,
          ),
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
