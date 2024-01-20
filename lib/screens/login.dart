import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:lev_mobile/constants.dart';
import 'package:lev_mobile/controllers/salary_controller.dart';
import 'package:lev_mobile/screens/register.dart';
import 'package:lev_mobile/screens/reset_password.dart';
import 'package:lev_mobile/styling/colors.dart';
import 'package:lev_mobile/widgets/button.dart';
import 'package:lev_mobile/widgets/form_field.dart';
import 'package:lev_mobile/widgets/shaped_background.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:lev_mobile/models/response_model.dart' as response;
import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool rememberMe = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SafeArea(
          child: SizedBox(
            width: size.width * 0.9,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/splash_icon.png",
                      height: size.height * 0.2,
                    ),
                    SizedBox(height: 25),
                    CustomFormField(
                      hintText: "Email",
                      icon: IconlyLight.message,
                      controller: _emailController,
                      type: CustomFormFieldTypes.email,
                    ),
                    CustomFormField(
                      hintText: "Mot de Passe",
                      icon: IconlyLight.lock,
                      isPassword: true,
                      marginBottom: 0,
                      controller: _passwordController,
                    ),
                    SizedBox(height: 8),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "souviens-toi de moi",
                            style: TextStyle(fontSize: 17.0),
                          ),
                          Checkbox(
                            value: rememberMe, onChanged: (bool? value) {
                              setState(() {
                                rememberMe = value ?? false;
                              });
                            },
                            activeColor: AppColors.primary,
                          )
                        ]
                    ),
                    CustomButton(text: "Se connecter", onTap: onSubmit),
                    SizedBox(height: 12,),
                    InkWell(
                      child: Text(
                        "Crée un nouveau compte",
                        style: TextStyle(fontSize: 17.0, color: AppColors.primary),
                      ),
                      onTap: () {
                        Get.to(() => Register());
                      },
                    ),
                    SizedBox(height: 12,),
                    InkWell(
                      child: Text(
                        "Votre compte est perdu ?",
                        style: TextStyle(fontSize: 17.0, color: AppColors.primary),
                      ),
                      onTap: () {
                        Get.to(() => ResetPassword());
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }

  void onSubmit() async {
    if (_formKey.currentState!.validate()) {
      SmartDialog.showLoading();
      response.Response res = await SalaryController.authenticateSalary(_emailController.text, _passwordController.text, rememberMe);
      SmartDialog.dismiss();
      if(res.success) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(message: res.message),
        );
        Get.offAll(() => Home());
      }else{
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(message: res.message),
        );
      }
    }
  }

}
