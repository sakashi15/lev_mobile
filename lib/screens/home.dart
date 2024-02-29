
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:iconly/iconly.dart';
import 'package:lev_mobile/constants.dart';
import 'package:lev_mobile/models/calculation_slot_model.dart';
import 'package:lev_mobile/models/salary_model.dart';
import 'package:lev_mobile/models/walked_step.dart';
import 'package:lev_mobile/network/my_http_client.dart';
import 'package:lev_mobile/screens/login.dart';
import 'package:lev_mobile/screens/profile.dart';
import 'package:lev_mobile/services/salary_service.dart';
import 'package:lev_mobile/styling/colors.dart';
import 'package:lev_mobile/widgets/button.dart';
import 'package:lev_mobile/widgets/shared.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var result;
  bool enableProfile = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int _getSteps = 0;
  int _getSteps2 = 0;
  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();

  List<int> lastStepsValues = [];
  List<String> lastStepsDates = [];
  int maxStep = 0;

  @override
  void initState() {
    super.initState();
    getSalary();

  }

  Future fetchStepData() async {
    int? steps;
    int? steps2;

    var types = [HealthDataType.STEPS,];

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    DateTime lastDate = DateTime.tryParse((result as Salary).lastWalkedStepsDate.toString()) ?? DateTime.now();
    lastDate = lastDate.add(Duration(days: 1));
    var permissions = [HealthDataAccess.READ,];

    bool requested = await health.requestAuthorization(types, permissions: permissions);

    if (requested) {
      try {


        int totalSteps = 0;
        int todayTotalSteps = 0;
        DateTime today = DateTime.now();
        for (DateTime date = lastDate; date.isBefore(today.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
          String weekday = rankToDay(date.weekday - 1);
          if(result.runtimeType == Salary && (result as Salary).calculationSlots != null) {
            List<CalculationSlot> slots = (result as Salary).calculationSlots!.where((element) => element.weekday == weekday).toList();

            if(slots.isNotEmpty) {
              for(CalculationSlot slot in slots) {
                DateTime start = DateTime.tryParse(date.toString().substring(0, 10) + " " + slot.startTime) ?? DateTime.now();
                DateTime end = DateTime.tryParse(date.toString().substring(0, 10) + " " + slot.endTime) ?? DateTime.now();
                int slotSteps = await health.getTotalStepsInInterval(start, end) ?? 0;
                totalSteps = totalSteps + slotSteps;
                if(date.compareTo(today) == 1) {
                  todayTotalSteps = todayTotalSteps + slotSteps;
                }


                print(date.toString().substring(0, 10) + " " + slot.startTime);
                print(date.toString().substring(0, 10) + " " + slot.endTime);
                print("rank: " + weekday);
                print("date: " + date.toString());
                print("slots: " + slots.toString());
                print("steps: " + slotSteps.toString());
                print("today: " + date.compareTo(today).toString());
                print("---------------------------------");
              }
            }
          }
        }
        steps2 = totalSteps;
        steps = todayTotalSteps;


      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      print('Total number of steps: $steps');

      setState(() {
        _getSteps = (steps == null) ? 0 : steps;
        _getSteps2 = (steps2 == null) ? 0 : steps2;
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }

  String rankToDay(rank) {
    switch(rank) {
      case 0:
        return "monday";
      case 1:
        return "tuesday";
      case 2:
        return "wednesday";
      case 3:
        return "thursday";
      case 4:
        return "friday";
      case 5:
        return "saturday";
      case 6:
        return "sunday";
    }
    return "sunday";
  }

  void getSalary() async {
    SmartDialog.showLoading();
    result = await SalaryService.profile();
    SmartDialog.dismiss();
    if(result != null && result.runtimeType == Salary) {
      fetchStepData();
      if((result as Salary).walkedSteps!.isNotEmpty) {
        lastStepsDates.clear();
        lastStepsValues.clear();
        maxStep = 0;
        for(WalkedStep walkedStep in (result as Salary).walkedSteps!) {
          lastStepsDates.add(reverseDate(walkedStep.stepsDate));
          lastStepsValues.add(walkedStep.steps);
          if(maxStep < walkedStep.steps) {
            maxStep = walkedStep.steps;
          }
        }
        print("------");
        print(lastStepsDates);
        print("------");
        print(lastStepsValues);
      }
      setState(() {
        enableProfile = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if(scaffoldKey.currentState != null) {
                scaffoldKey.currentState!.openEndDrawer();
              }
            },
            icon: Icon(Icons.menu, color: AppColors.primary,)
        ),
        title: Image.asset("assets/images/launcher_icon.png", height: 32,),
        backgroundColor: Colors.white,
        centerTitle: false,
        actions: [
          if(enableProfile)
            IconButton(
                onPressed: () async {
                  Get.to(() => Profile(
                    salary: result as Salary,
                    totalValidatedSteps: (result as Salary).walkingSteps ?? 0,
                    completedChallenges: (result as Salary).completedChallenges ?? [],
                  ));
                },
                icon: Container(
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.all(Radius.circular(75)),
                    child: Image.asset("assets/images/avatar.png"),
                  ),
                ),
            )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(lastStepsDates.isNotEmpty && lastStepsValues.isNotEmpty && maxStep > 0)
              Container(
                padding: EdgeInsets.only(left: 18, right: 28),
                height: 250,
                child: Chart(
                  layers: [
                    ChartAxisLayer(
                      settings: ChartAxisSettings(
                        x: ChartAxisSettingsAxis(
                          frequency: 1.0,
                          max: lastStepsValues.length - 1,
                          min: 0,
                          textStyle: TextStyle(
                            color: AppColors.primary.withOpacity(0.6),
                            fontSize: 10.0,
                          ),
                        ),
                        y: ChartAxisSettingsAxis(
                          frequency: maxStep.toDouble() / 10,
                          max: maxStep.toDouble(),
                          min: 0.0,
                          textStyle: TextStyle(
                            color: AppColors.primary.withOpacity(0.6),
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                      labelX: (value) => lastStepsDates[value.toInt()].toString(),
                      labelY: (value) => value.toInt().toString(),
                    ),
                    ChartLineLayer(
                      items: List.generate(
                        lastStepsValues.length,
                            (index) => ChartLineDataItem(
                          value: lastStepsValues[index].toDouble(),
                          x: index.toDouble(),
                        ),
                      ),
                      settings: const ChartLineSettings(
                        thickness: 8.0,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              if(lastStepsDates.isNotEmpty && lastStepsValues.isNotEmpty && maxStep > 0)
              SizedBox(height: 24),
              if(lastStepsDates.isNotEmpty && lastStepsValues.isNotEmpty && maxStep > 0)
              Text("Résultats des 04 derniers validations", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.simple)),
              SizedBox(height: 32),
              if(result != null && result.runtimeType == Salary)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    simpleCard(reverseDate((result as Salary).lastWalkedStepsDate.toString()), "Maj."),
                    simpleCard("Pas total", (result as Salary).walkingSteps.toString()),
                    simpleCard("Lev", (result as Salary).lev.toString()),
                  ],
                ),
              SizedBox(height: 30),
              /*Container(
                  child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                            minimum: 0, maximum: 150,
                            ranges: <GaugeRange>[
                              GaugeRange(startValue: 0, endValue: 50, color:Colors.green),
                              GaugeRange(startValue: 50,endValue: 100,color: Colors.orange),
                              GaugeRange(startValue: 100,endValue: 150,color: Colors.red)
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(value: 90)
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(widget: Container(child:
                                Text('90.0',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                                  angle: 90, positionFactor: 0.5
                              )
                            ]
                        )])
              ),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/bot.png"),
                  SizedBox(width: 8),
                  Text("$_getSteps2", style: TextStyle(fontSize: 25, color: Color(0xFFC2C2C2), fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  if(result != null && result.runtimeType == Salary)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                          "depuis: ${reverseDate((result as Salary).lastWalkedStepsDate.toString())}",
                          style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFFC2C2C2),
                              fontWeight: FontWeight.bold
                          )
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10),
              Text("$_getSteps Aujourdhui", style: TextStyle(fontSize: 15, color: Color(0xFFC2C2C2), fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                  child: CustomButton(
                    text: "Valider mes pas",
                    height: 50,
                    padding: 10,
                    onTap: () async {
                      if(_getSteps2 > 0) {
                        SmartDialog.showLoading();
                        bool success = await SalaryService.validateSteps(
                            DateTime.now().toString().substring(0, 10),
                            TempSalary.temp ? TempSalary.id : box.read(MyHttpClient.id),
                            _getSteps2
                        );
                        SmartDialog.dismiss();
                        if(success) {
                          getSalary();
                        }
                      }
                    },
                  ),
              )
            ],
          ),
        ),
      ),
      drawer: Drawer(
        key: scaffoldKey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: (enableProfile) ? Column(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.all(Radius.circular(90)),
                      child: Image.asset("assets/images/avatar.png", height: 80,),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text((result.firstName ?? "") + " " + ( result.lastName ?? ""), style: TextStyle(fontSize: 16, color: Color(0xFF747474), fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(result.email ?? "---", style: TextStyle(fontSize: 12, color: Color(0xFFBCBCBC), fontWeight: FontWeight.bold)),
                ],
              ) : Image.asset("assets/images/launcher_icon.png", height: 10,),
              decoration: BoxDecoration(
                color: AppColors.primaryLess4,
              ),
            ),
            ListTile(
              leading: Icon(IconlyLight.home),
              title: Text('Accueil'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(IconlyLight.profile),
              title: Text("Profil"),
              onTap: () {
                if(enableProfile) {
                  Get.to(() => Profile(
                    salary: result as Salary,
                    totalValidatedSteps: (result as Salary).walkingSteps ?? 0,
                    completedChallenges: (result as Salary).completedChallenges ?? [],
                  ));
                }
              },
            ),
            ListTile(
              leading: Icon(IconlyLight.logout),
              title: Text("Déconnexion"),
              onTap: () async {
                SmartDialog.showLoading();
                await SalaryService.logout();
                SmartDialog.dismiss();
                Get.offAll(() => Login());
              },
            ),
          ],
        ),
      ),
    );
  }

}
