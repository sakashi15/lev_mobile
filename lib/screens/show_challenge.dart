import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:lev_mobile/constants.dart';
import 'package:lev_mobile/models/challenge_model.dart';
import 'package:lev_mobile/models/company_model.dart';
import 'package:lev_mobile/models/salary_model.dart';
import 'package:lev_mobile/network/my_http_client.dart';
import 'package:lev_mobile/screens/home.dart';
import 'package:lev_mobile/services/salary_service.dart';
import 'package:lev_mobile/styling/colors.dart';
import 'package:lev_mobile/widgets/button.dart';
import 'package:lev_mobile/widgets/my_network_image.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ShowChallenge extends StatefulWidget {
  Challenge challenge;
  int totalValidatedSteps;
  ShowChallenge({
    Key? key,
    required this.challenge,
    required this.totalValidatedSteps,
  }) : super(key: key);

  @override
  State<ShowChallenge> createState() => _ShowChallengeState();
}

class _ShowChallengeState extends State<ShowChallenge> {

  int stepsPercent = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.challenge.steps != null && widget.totalValidatedSteps >= widget.challenge.steps!){
      stepsPercent = 100;
    }
    if(widget.challenge.steps != null && widget.totalValidatedSteps < widget.challenge.steps!){
      stepsPercent = ((widget.totalValidatedSteps * 100) / widget.challenge.steps!).toInt();
    }
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
        title: Text("Détails du défis", style: TextStyle(color: Color(0xFF747474), fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.white,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(widget.challenge.logo.toString().isNotEmpty)
              Stack(
                children: [
                  MyNetworkImage(
                    url: MyHttpClient.root + widget.challenge.logo!,
                    height: 250,
                    width: size.width,
                  ),
                  Positioned(
                    bottom: 12,
                    right: 10,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(40))
                      ),
                      child: CircularStepProgressIndicator(
                        totalSteps: 100,
                        currentStep: stepsPercent,
                        stepSize: 6,
                        selectedColor: AppColors.primaryLess,
                        unselectedColor: Colors.grey[200],
                        padding: 0,
                        width: 40,
                        height: 40,
                        selectedStepSize: 6,
                        roundedCap: (_, __) => true,
                        child: Center(child: Text("${stepsPercent}%", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),)),
                      ),
                    ),
                  )
                ],
              ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 18),
                  Text(
                      widget.challenge.title ?? "---",
                      style: TextStyle(
                          color: Color(0xFF747474),
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      )
                  ),
                  SizedBox(height: 8),
                  Text(
                      (widget.challenge.steps ?? "0").toString() + " Pas",
                      style: TextStyle(
                          color: Color(0xFF8D8D8D),
                          fontSize: 11
                      )
                  ),
                  SizedBox(height: 18),
                  Text(
                    widget.challenge.description ?? "---",
                    style: TextStyle(
                      color: Color(0xFF747474),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 12),
                  Divider(),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                          "Delais du defis",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF747474),
                          )
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.access_time, size: 14, color: Color(0xFF747474),)
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text("Depuis:  ") ,
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFD0D0D0),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                            child: Text(
                                (widget.challenge.startDate != null && widget.challenge.startDate.toString().isNotEmpty) ?
                                widget.challenge.startDate!.substring(0, 10).split("-").reversed.join("-") :
                                "---",
                                style: TextStyle(
                                    color: Color(0xFF747474),
                                    fontWeight: FontWeight.bold
                                )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Row(
                        children: [
                          Text("Jusqu'a:  ") ,
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFD0D0D0),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                            child: Text(
                                (widget.challenge.endDate != null && widget.challenge.endDate.toString().isNotEmpty) ?
                                widget.challenge.endDate!.substring(0, 10).split("-").reversed.join("-") :
                                "---",
                                style: TextStyle(
                                    color: Color(0xFF747474),
                                    fontWeight: FontWeight.bold
                                )
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16,),
                  Row(
                    children: [
                      Text(
                          "Les entreprise (" + widget.challenge.companies.length.toString() +")",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF747474),
                          )
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.account_balance_sharp, size: 14, color: Color(0xFF747474),)
                    ],
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for(Company company in widget.challenge.companies)
                          if(company.name.toString().isNotEmpty)
                            companyChip(company.name!)
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  if(widget.totalValidatedSteps >= widget.challenge.steps!)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 80,
                        child: CustomButton(
                          text: "Gagner le défis",
                          height: 50,
                          padding: 10,
                          onTap: () async {
                            SmartDialog.showLoading();
                            bool success = await SalaryService.validateChallenge(
                                widget.challenge.steps ?? 0,
                                TempSalary.temp ? TempSalary.id : box.read(MyHttpClient.id),
                                widget.challenge.id ?? 0
                            );
                            SmartDialog.dismiss();
                            if(success) {
                              Get.offAll(() => Home());
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget companyChip(String companyName) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
          color: AppColors.chip,
          borderRadius: BorderRadius.all(Radius.circular(12))
      ),
      padding: EdgeInsets.only(left: 6, right: 10, top: 4, bottom: 4),
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                color: AppColors.avatar,
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Center(
              child: Text(
                (companyName.toString().isNotEmpty) ?
                companyName[0].toUpperCase() :
                  "-",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12
                ),
              ),
            )
          ),
          SizedBox(width: 6),
          Text(
            (companyName.toString().isNotEmpty) ?
            companyName :
            "-",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12
            ),
          )
        ],
      ),
    );
  }
}
