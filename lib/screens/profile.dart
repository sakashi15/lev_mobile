import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polygon_clipper/flutter_polygon_clipper.dart';
import 'package:get/get.dart';
import 'package:lev_mobile/models/challenge_model.dart';
import 'package:lev_mobile/models/salary_model.dart';
import 'package:lev_mobile/network/my_http_client.dart';
import 'package:lev_mobile/screens/edit_profile.dart';
import 'package:lev_mobile/screens/show_challenge.dart';
import 'package:lev_mobile/screens/show_company.dart';
import 'package:lev_mobile/styling/colors.dart';
import 'package:lev_mobile/widgets/my_network_image.dart';
import 'package:lev_mobile/widgets/shared.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Profile extends StatefulWidget {
  Salary salary;
  int totalValidatedSteps;
  List<int> completedChallenges;
  Profile({
    Key? key,
    required this.salary,
    required this.totalValidatedSteps,
    required this.completedChallenges,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

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
        title: Text("Mon Profil", style: TextStyle(color: Color(0xFF747474), fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.white,
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => EditProfile(salary: widget.salary));
              },
              icon: Icon(Icons.edit, color: AppColors.primary,)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 18,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 12),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.all(Radius.circular(75)),
                    child: Image.asset("assets/images/avatar.png", height: 75,),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text((widget.salary.firstName ?? "") + " " +( widget.salary.lastName ?? ""), style: TextStyle(fontSize: 20, color: Color(0xFF747474), fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text(widget.salary.email ?? "---", style: TextStyle(fontSize: 15, color: Color(0xFFBCBCBC), fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    GestureDetector(
                        child: Text(
                            "Chez: " + (widget.salary.company!.name ?? "---"),
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFBCBCBC),
                                fontWeight: FontWeight.bold
                            )
                        ),
                      onTap: () {
                        if(widget.salary.company != null) {
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                              ),
                              builder: (context) {
                                return Container(
                                  height: size.height * 0.98,
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: ShowCompany(company: widget.salary.company!,),
                                );
                              }
                          );
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(width: 12),
              ],
            ),
            SizedBox(height: 18,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                simpleCard("Défi Terminé", widget.completedChallenges.length.toString()),
                simpleCard("Défis Dispo.", (widget.salary.company!.challenges.length - widget.completedChallenges.length).toString()),
                simpleCard("Lev", (widget.salary.lev! ?? 0.0).toString()),
              ],
            ),
            SizedBox(height: 24),
            Container(
              margin: EdgeInsets.only(left: 18),
                child: Text(
                  "Défis disponibles (${widget.salary.company!.challenges.length - widget.completedChallenges.length})",
                  textAlign: TextAlign.left,
                )
            ),
            SizedBox(height: 9,),
            if(widget.salary.company != null)
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.salary.company!.challenges.length,
                  itemBuilder: (BuildContext context, int index) {
                    if(!widget.completedChallenges.contains(widget.salary.company!.challenges[index].id)) {
                      return Container(
                        margin: EdgeInsets.only(top: 8),
                        child: ListTile(
                          leading: (widget.salary.company!.challenges[index]
                              .logo
                              .toString()
                              .isNotEmpty) ? FlutterClipPolygon(
                                sides: 5,
                                borderRadius: 5.0, // Defaults to 0.0 degrees
                                boxShadows: [
                                  PolygonBoxShadow(
                                      color: AppColors.primary, elevation: 1.0),
                                  PolygonBoxShadow(
                                      color: Colors.grey, elevation: 3.0)
                                ],
                                child: MyNetworkImage(
                                  url: MyHttpClient.root +
                                      widget.salary.company!.challenges[index]
                                          .logo!,
                                  height: 20,
                                  width: 20,
                                ),
                              ) : null,
                          trailing: CircularStepProgressIndicator(
                            totalSteps: 100,
                            currentStep: getTotalPercent(widget.salary.company!
                                .challenges[index]),
                            stepSize: 4,
                            selectedColor: AppColors.primaryLess,
                            unselectedColor: Colors.grey[200],
                            padding: 0,
                            width: 35,
                            height: 35,
                            selectedStepSize: 4,
                            roundedCap: (_, __) => true,
                            child: Center(child: Text("${getTotalPercent(
                                widget.salary.company!.challenges[index])}%",
                              style: TextStyle(
                                  fontSize: 8, fontWeight: FontWeight.bold),)),
                          ),
                          title: Text(widget.salary.company!.challenges[index]
                              .title ?? "---", style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.bold),),
                          subtitle: Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Text(
                                  widget.salary.company!.challenges[index]
                                      .description ?? "---"
                              )
                          ),
                          onTap: () {
                            Get.to(() =>
                                ShowChallenge(
                                  challenge: widget.salary.company!
                                      .challenges[index],
                                  totalValidatedSteps: widget
                                      .totalValidatedSteps,
                                )
                            );
                          },
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }
              ),
            //SizedBox(height: 24),
            Container(
                margin: EdgeInsets.only(left: 18),
                child: Text(
                  "Défis terminé (${widget.completedChallenges.length})",
                  textAlign: TextAlign.left,
                )
            ),
            SizedBox(height: 9,),
            if(widget.salary.company != null)
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.salary.company!.challenges.length,
                  itemBuilder: (BuildContext context, int index) {
                    if(widget.completedChallenges.contains(widget.salary.company!.challenges[index].id)) {
                      return Container(
                        margin: EdgeInsets.only(top: 8),
                        child: ListTile(
                          leading: (widget.salary.company!.challenges[index]
                              .logo
                              .toString()
                              .isNotEmpty) ? FlutterClipPolygon(
                            sides: 5,
                            borderRadius: 5.0, // Defaults to 0.0 degrees
                            boxShadows: [
                              PolygonBoxShadow(
                                  color: AppColors.primary, elevation: 1.0),
                              PolygonBoxShadow(
                                  color: Colors.grey, elevation: 3.0)
                            ],
                            child: MyNetworkImage(
                              url: MyHttpClient.root +
                                  widget.salary.company!.challenges[index]
                                      .logo!,
                              height: 20,
                              width: 20,
                            ),
                          ) : null,
                          title: Text(widget.salary.company!.challenges[index]
                              .title ?? "---", style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.bold),),
                          subtitle: Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Text(
                                  widget.salary.company!.challenges[index]
                                      .description ?? "---"
                              )
                          ),
                          onTap: () {
                            /*Get.to(() =>
                                ShowChallenge(
                                  challenge: widget.salary.company!
                                      .challenges[index],
                                  totalValidatedSteps: widget
                                      .totalValidatedSteps,
                                )
                            );*/
                          },
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }
              )
          ],
        ),
      ),
    );
  }

  int getTotalPercent(Challenge challenge) {
    if(challenge.steps != null && widget.totalValidatedSteps >= challenge.steps!){
      return 100;
    }
    if(challenge.steps != null && widget.totalValidatedSteps < challenge.steps!){
      return ((widget.totalValidatedSteps * 100) / challenge.steps!).toInt();
    }
    return 0;
  }
}
