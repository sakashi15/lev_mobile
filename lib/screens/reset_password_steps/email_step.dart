import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lev_mobile/widgets/form_field.dart';

class EmailStep extends StatefulWidget {
  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  EmailStep({
    Key? key,
    required this.formKey,
    required this.emailController,
  }) : super(key: key);

  @override
  State<EmailStep> createState() => _EmailStepState();
}

class _EmailStepState extends State<EmailStep> {
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
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
