import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lev_mobile/models/salary_model.dart';
import 'package:lev_mobile/screens/login.dart';
import 'package:lev_mobile/screens/register.dart';
import 'package:lev_mobile/screens/registration_steps/third_step.dart';
import 'package:lev_mobile/screens/reset_password_steps/email_step.dart';
import 'package:lev_mobile/screens/reset_password_steps/password_step.dart';
import 'package:lev_mobile/services/salary_service.dart';
import 'package:lev_mobile/styling/colors.dart';
import 'package:lev_mobile/widgets/shaped_background.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  int activeStep2 = 0;
  int reachedStep = 0;
  int upperBound = 2;
  Set<int> reachedSteps = <int>{0, 1, 2};

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  String otpCode = "";
  String currentOtp = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SafeArea(
          child: SizedBox(
            width: size.width * 0.9,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/splash_icon.png",
                    height: size.height * 0.2,
                  ),
                  SizedBox(height: 25),
                  EasyStepper(
                    enableStepTapping: false,
                    activeStep: activeStep2,
                    maxReachedStep: reachedStep,

                    activeStepBorderColor: AppColors.primary,
                    activeStepIconColor: AppColors.primary,
                    activeStepTextColor: AppColors.primary,
                    lineStyle: LineStyle(
                      lineLength: 120,
                      lineSpace: 4,
                      lineType: LineType.normal,
                      activeLineColor: Colors.grey.withOpacity(0.5),
                      unreachedLineColor: Colors.grey.withOpacity(0.5),
                      finishedLineColor: AppColors.primaryLess,
                    ),
                    activeStepBackgroundColor: Colors.white,
                    unreachedStepBackgroundColor: Colors.grey.withOpacity(0.5),
                    unreachedStepBorderColor: Colors.grey.withOpacity(0.5),
                    unreachedStepIconColor: Colors.grey,
                    unreachedStepTextColor: Colors.grey.withOpacity(0.5),
                    finishedStepBackgroundColor: AppColors.primaryLess4,
                    finishedStepBorderColor: AppColors.primaryLess,
                    finishedStepIconColor: AppColors.primaryLess,
                    finishedStepTextColor: AppColors.primaryLess,
                    borderThickness: 2,
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 8),
                    internalPadding: 0,
                    showLoadingAnimation: false,
                    steps: [
                      EasyStep(
                        icon: const Icon(CupertinoIcons.info),
                        title: 'Email',
                        lineText: "Confirmation de l'Email",
                        enabled: _allowTabStepping(0, StepEnabling.sequential),
                      ),
                      EasyStep(
                        icon: const Icon(Icons.account_circle),
                        title: 'Code OTP',
                        lineText: 'Confirmation du compte',
                        enabled: _allowTabStepping(1, StepEnabling.sequential),
                      ),
                      EasyStep(
                        icon: const Icon(Icons.check_circle_outline),
                        title: 'Finalisation',
                        enabled: _allowTabStepping(2, StepEnabling.sequential),
                      ),
                    ],
                    onStepReached: (index) => setState(() {
                      activeStep2 = index;
                    }),
                  ),
                  if (activeStep2 == 0)
                    EmailStep(
                      formKey: _formKey1,
                      emailController: _emailController,
                    ),
                  if (activeStep2 == 1)
                    OtpStep(
                      formKey: _formKey2,
                      onCompleted: (pin) {
                        print(pin);
                        setState(() {
                          otpCode = pin;
                        });
                      },
                    ),
                  if (activeStep2 == 2)
                    PasswordStep(
                        formKey: _formKey3,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController
                    ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (activeStep2 != 0 && activeStep2 != 2)
                          _previousStep(StepEnabling.sequential)
                        else
                          Spacer(),
                        _nextStep(StepEnabling.sequential),
                      ],
                    ),
                  ),
                  SizedBox(height: 12,),
                  if(activeStep2 == 1)
                    InkWell(
                      child: Text(
                        "Renvoyer un code OTP",
                        style: TextStyle(fontSize: 17.0, color: AppColors.primary),
                      ),
                      onTap: () {
                        sendOTPCode();
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> sendOTPCode() async {
    SmartDialog.showLoading();
    var res = await SalaryService.regenerateOtp(_emailController.text);
    SmartDialog.dismiss();
    if(res.status) {
      setState(() {
        currentOtp = res.token;
      });
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(message: "l'Envoi du code réussie"),
      );
      return true;
    }else {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: "l'Envoi du code échoue"),
      );
      return false;
    }
  }

  bool _allowTabStepping(int index, StepEnabling enabling) {
    return enabling == StepEnabling.sequential
        ? index <= reachedStep
        : reachedSteps.contains(index);
  }

  /// Returns the next button.
  Widget _nextStep(StepEnabling enabling) {
    return GFButton(
      onPressed: () async {
        if (activeStep2 < upperBound) {
          GlobalKey<FormState> formKey = (activeStep2 == 0) ? _formKey1 : ((activeStep2 == 1) ? _formKey2 : _formKey3);
          if(formKey.currentState!.validate()) {
            bool done = true;
            if(activeStep2 == 0) {
              SmartDialog.showLoading();
              done = await sendOTPCode();
              SmartDialog.dismiss();
            }
            if(activeStep2 == 1 && currentOtp == otpCode) {
              SmartDialog.showLoading();
              bool done = await SalaryService.activate(_emailController.text);
              SmartDialog.dismiss();
            }
            if(done) {
              setState(() {
                if (enabling == StepEnabling.sequential) {
                  ++activeStep2;
                  if (reachedStep < activeStep2) {
                    reachedStep = activeStep2;
                  }
                } else {
                  activeStep2 = reachedSteps.firstWhere((element) => element > activeStep2);
                }
              });
            }
          }
        }else{
          if(_passwordController.text == _confirmPasswordController.text) {
            bool done = await updateSalaryPassword();
            if(done) {
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.success(message: "Opératiion réussie"),
              );
              Get.offAll(() => Login());
            }
          }else{
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(message: "Vérifier le mot de passe et ca confirmation"),
            );
          }
        }
      },
      text: (activeStep2 == 2) ? "Terminer" : "Suivant",
      size: GFSize.LARGE,
      position: GFPosition.end,
      icon: (activeStep2 == 2) ? null : Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: Colors.white,
      ),
      color: AppColors.primary,
      padding: EdgeInsets.only(left: 16, right: (activeStep2 == 2) ? 19 : 8),
    );
  }

  /// Returns the previous button.
  Widget _previousStep(StepEnabling enabling) {
    return GFButton(
      onPressed: () {
        if (activeStep2 > 0) {
          setState(() => enabling == StepEnabling.sequential
              ? --activeStep2
              : activeStep2 =
              reachedSteps.lastWhere((element) => element < activeStep2));
        }
      },
      text: "Précédent",
      textStyle:
      TextStyle(fontFamily: 'Ubuntu', color: AppColors.primary),
      size: GFSize.LARGE,
      type: GFButtonType.outline,
      position: GFPosition.start,
      icon: Icon(
        Icons.arrow_back_ios,
        size: 18,
        color: AppColors.primary,
      ),
      color: AppColors.primary,
      padding: EdgeInsets.only(left: 12, right: 16),
    );
  }

  Future<bool> updateSalaryPassword() async {
    SmartDialog.showLoading();
    var res = await SalaryService.updatePassword(
        _emailController.text,
        _passwordController.text
    );
    SmartDialog.dismiss();
    return res;
  }
}
