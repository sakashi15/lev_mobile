import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:lev_mobile/constants.dart';
import 'package:lev_mobile/screens/home.dart';
import 'package:lev_mobile/screens/login.dart';
import 'package:lev_mobile/services/salary_service.dart';
import 'package:lev_mobile/styling/theme.dart';
import 'package:get_storage/get_storage.dart';

bool authenticated = false;

void main() async {
  await GetStorage.init();
  box = GetStorage();
  authenticated = SalaryService.isAuthenticated();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light(),
      home: (authenticated) ? Home() : Login(),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      locale: Locale('fr'),
    );
  }
}