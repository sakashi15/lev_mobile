import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:lev_mobile/models/salary_model.dart';
import 'package:lev_mobile/network/my_http_client.dart';
import 'package:lev_mobile/screens/change_password.dart';
import 'package:lev_mobile/screens/home.dart';
import 'package:lev_mobile/services/salary_service.dart';
import 'package:lev_mobile/styling/colors.dart';
import 'package:lev_mobile/styling/theme.dart';
import 'package:lev_mobile/widgets/button.dart';
import 'package:lev_mobile/widgets/form_field.dart';
import 'package:lev_mobile/widgets/my_network_image.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class EditProfile extends StatefulWidget {
  Salary salary;
  EditProfile({
    Key? key,
    required this.salary
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.salary.firstName ?? "---";
    lastNameController.text = widget.salary.lastName ?? "---";
    phoneController.text = widget.salary.phone ?? "---";
    emailController.text = widget.salary.email ?? "---";
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_outlined, color: AppColors.primary,)
        ),
        title: Text(
            "Modifier mon profil",
            style: TextStyle(
                color: Color(0xFF747474),
                fontWeight: FontWeight.bold,
                fontSize: 20
            )
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                    builder: (context) {
                      return Container(
                        height: size.height * 0.50,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: ChangePassword(),
                      );
                    }
                );
              },
              icon: Icon(Icons.password, color: AppColors.primary,)
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 18),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.all(Radius.circular(75)),
                      child: Image.asset("assets/images/avatar.png", height: 100,),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                CustomFormField(
                  hintText: "Nom",
                  icon: IconlyLight.profile,
                  controller: firstNameController,
                  type: CustomFormFieldTypes.text,
                ),
                CustomFormField(
                  hintText: "Prénom",
                  icon: IconlyLight.profile,
                  controller: lastNameController,
                  type: CustomFormFieldTypes.text,
                ),
                CustomFormField(
                  hintText: "Téléphone",
                  icon: IconlyLight.call,
                  controller: phoneController,
                  type: CustomFormFieldTypes.text,
                ),
                CustomFormField(
                  hintText: "Email",
                  icon: IconlyLight.message,
                  controller: emailController,
                  type: CustomFormFieldTypes.email,
                  readOnly: true,
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.only(right: 12, left: 22),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(12)),
                    border: Border.all(
                        color: Color(0xFFEDEDF3),
                        width: 1.0,
                        style: BorderStyle.solid),
                    color: Color(0xFFF8F7F7),
                  ),
                  child: Row(
                    children: [
                      if(widget.salary.company!.logo != null && widget.salary.company!.logo!.isNotEmpty)
                        ClipRRect(
                          child: MyNetworkImage(
                            url: MyHttpClient.root + widget.salary.company!.logo!,
                            height: 20,
                            width: 20,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        )
                      else
                        Icon(IconlyLight.home, color: AppColors.darkBlue.withOpacity(0.3),),
                      SizedBox(width: 18),
                      Text(
                          widget.salary.company!.name!,
                          style: TextStyle(
                            fontFamily: fontName,
                            fontSize: 14,
                          )
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 35, right: 22, left: 22),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 80,
          child: CustomButton(
            text: "Enregistrer",
            height: 50,
            padding: 10,
            onTap: () async {
              if(_formKey.currentState!.validate()) {
                SmartDialog.showLoading();
                var res = await SalaryService.updateSalary(
                    widget.salary.id!,
                    firstNameController.text,
                    lastNameController.text,
                    phoneController.text
                );
                SmartDialog.dismiss();
                if (res) {
                  showTopSnackBar(
                    Overlay.of(context),
                    CustomSnackBar.success(message: "Opération réussie"),
                  );
                  Get.offAll(() => Home());
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
      ),
    );
  }
}
