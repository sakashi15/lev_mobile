import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lev_mobile/models/company_model.dart';
import 'package:lev_mobile/models/otp_model.dart';
import 'package:lev_mobile/models/salary_model.dart';
import 'package:lev_mobile/screens/login.dart';
import 'package:lev_mobile/screens/registration_steps/first_step.dart';
import 'package:lev_mobile/screens/registration_steps/second_step.dart';
import 'package:lev_mobile/screens/registration_steps/third_step.dart';
import 'package:lev_mobile/services/company_service.dart';
import 'package:lev_mobile/services/salary_service.dart';
import 'package:lev_mobile/styling/colors.dart';
import 'package:lev_mobile/widgets/shaped_background.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'home.dart';


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  int activeStep2 = 0;
  int reachedStep = 0;
  int upperBound = 2;
  Set<int> reachedSteps = <int>{0, 1, 2};

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  int selectedValue = -1;
  String? selectedValueString;

  String otpCode = "";
  String currentOtp = "";

  List<Company> companies = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllCompanies();
  }

  void getAllCompanies() async {
    SmartDialog.showLoading();
    companies = await CompanyService.getAllCompanies();
    SmartDialog.dismiss();
    setState(() {});
  }

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
                          title: 'Information',
                          lineText: "Information de compte",
                          enabled: _allowTabStepping(0, StepEnabling.sequential),
                        ),
                        EasyStep(
                          icon: const Icon(Icons.account_circle),
                          title: 'Connexion',
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
                      InformationStep(
                          formKey: _formKey1,
                          firstNameController: _firstNameController,
                          lastNameController: _lastNameController,
                          phoneController: _phoneController,
                        selectedValue: selectedValue,
                        companies: companies,
                        selectedValueString: selectedValueString,
                        onCompanySelected: (value) {
                          selectedValueString = value;
                          selectedValue = companies
                              .firstWhere((element) =>
                          element.name == value)
                              .id!;
                          setState(() {});
                        },
                      ),
                    if (activeStep2 == 1)
                      AccountStep(
                          formKey: _formKey2,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController
                      ),
                    if (activeStep2 == 2)
                      OtpStep(
                        formKey: _formKey3,
                        onCompleted: (pin) {
                          print(pin);
                          setState(() {
                            otpCode = pin;
                          });
                        },
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
                    if(activeStep2 == 2)
                    InkWell(
                      child: Text(
                        "Renvoyer un code OTP",
                        style: TextStyle(fontSize: 17.0, color: AppColors.primary),
                      ),
                      onTap: () async {
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
                        }else {
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.error(message: "l'Envoi du code échoue"),
                          );
                        }
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
            if(activeStep2 == 0 && selectedValue == -1) {
              done = false;
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.error(message: "Veuillez seléctionner votre entreprise"),
              );
            }
            if(activeStep2 == 1) {
              if(_passwordController.text == _confirmPasswordController.text) {
                done = await registerSalary();
              }else{
                done = false;
                showTopSnackBar(
                  Overlay.of(context),
                  CustomSnackBar.error(message: "Vérifier le mot de passe et ca confirmation"),
                );
              }
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
          if(currentOtp == otpCode) {
            SmartDialog.showLoading();
            bool done = await SalaryService.activate(_emailController.text);
            SmartDialog.dismiss();
            if(done) {
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.success(message: "Inscription réussie"),
              );
              Get.offAll(() => Login());
            }else{
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.error(message: "Inscription échoue"),
              );
            }
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

  Future<bool> registerSalary() async {
    print(selectedValue);
    SmartDialog.showLoading();
    Salary salary = Salary.init(
        _firstNameController.text,
        _lastNameController.text,
        _emailController.text,
        _phoneController.text,
        _passwordController.text,
        selectedValue
    );
    var res = await SalaryService.register(salary);
    SmartDialog.dismiss();
    if(res.runtimeType == Otp) {
      if(res.status) {
        setState(() {
          currentOtp = res.token;
        });
        return true;
      }
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: "Inscription échoue"),
      );
      return false;
    }else{
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: res.message),
      );
      return false;
    }
  }

}

enum StepEnabling { sequential, individual }
