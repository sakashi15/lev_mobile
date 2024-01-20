import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:lev_mobile/screens/login.dart';
import 'package:lev_mobile/services/salary_service.dart';
import 'package:lev_mobile/widgets/button.dart';
import 'package:lev_mobile/widgets/form_field.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 12),
            Text(
                "Changement du Mot de Passe",
                style: TextStyle(
                    color: Color(0xFF747474),
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                )
            ),
            SizedBox(height: 22),
            CustomFormField(
              hintText: "Ancient Mot de Passe",
              icon: IconlyLight.lock,
              isPassword: true,
              controller: oldPasswordController,
            ),
            CustomFormField(
              hintText: "Nouveau Mot de Passe",
              icon: IconlyLight.lock,
              isPassword: true,
              controller: newPasswordController,
            ),
            CustomFormField(
              hintText: "Confirmer Nouveau Mot de Passe",
              icon: IconlyLight.lock,
              isPassword: true,
              controller: confirmNewPasswordController,
            ),
            SizedBox(height: 18),
            Container(
              //margin: EdgeInsets.only(bottom: 35, right: 22, left: 22),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: CustomButton(
                  text: "Valider",
                  height: 50,
                  padding: 10,
                  onTap: () async {
                    if(_formKey.currentState!.validate() && newPasswordController.text == confirmNewPasswordController.text) {
                      SmartDialog.showLoading();
                      var res = await SalaryService.resetSalaryPassword(
                          oldPasswordController.text,
                          newPasswordController.text
                      );
                      SmartDialog.dismiss();
                      if (res) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.success(message: "Opération réussie"),
                        );
                        Get.offAll(() => Login());
                      } else {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(message: "Opération échoue"),
                        );
                      }
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
