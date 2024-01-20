import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:lev_mobile/constants.dart';
import 'package:lev_mobile/models/otp_model.dart';
import 'package:lev_mobile/models/response_model.dart';
import 'package:lev_mobile/models/salary_model.dart';
import 'package:lev_mobile/network/my_http_client.dart';
import 'package:lev_mobile/network/urls.dart';

class SalaryService {

  static Future<Response> authenticate(Salary salary, bool rememberMe) async {
    final response = await MyHttpClient.post(
        path: URLs.loginSalary,
        data: salary.loginToJson()
    );
    final result = jsonDecode(response.body);
    print(salary.loginToJson());
    print(result);
    final data = result["salary"];
    if(response.statusCode == HttpStatus.ok) {
      if(rememberMe){
        box.write(MyHttpClient.authenticated, true);
        box.write(MyHttpClient.token, result["access_token"]);
        box.write(MyHttpClient.id, data["id"]);
        box.write(MyHttpClient.email, data["email"]);
        box.write(MyHttpClient.name, data["first_name"] + data["last_name"]);
      }else{
        TempSalary.temp = true;
        TempSalary.token = result["access_token"];
        TempSalary.id = data["id"];
        TempSalary.email = data["email"];
        TempSalary.phone = data["phone"];
        TempSalary.fullName = data["first_name"] + data["last_name"];
      }
    }
    return Response(result["success"] ?? false, result["message"]);
  }

  static Future<dynamic> register(Salary salary) async {
    final response = await MyHttpClient.post(
        path: URLs.registerSalary,
        data: salary.registerToJson()
    );
    final result = jsonDecode(response.body);
    print(result.toString());
    if(response.statusCode == HttpStatus.ok) {
      bool success = result["success"] as bool;
      if(success) {
        return Otp(result["1"]["status"] as bool, result["1"]["token"].toString(), result["1"]["message"].toString());
      }else{
        return Response(false, "Inscription échoue");
      }
    }else{
      String s = "";
      for (var val in result['errors'].values) {
        s = s + val[0] + "\n";
      }
      return Response(false, s);
    }
  }

  static Future<dynamic> profile() async {
    final response = await MyHttpClient.get(
      path: URLs.getSalary,
      isAuthenticated: true
    );
    final result = jsonDecode(response.body);
    log("--> " + result.toString());
    if(response.statusCode == HttpStatus.ok) {
      Salary salary = Salary.dataFromJson(result['data']);
      return salary;
    }else{
      return false;
    }
  }

  static Future<bool> activate(String email) async {
    final response = await MyHttpClient.post(
        path: URLs.activateSalary,
        data: {
          "email": email
        },
    );
    final result = jsonDecode(response.body);
    log(result.toString());
    if(response.statusCode == HttpStatus.ok) {
      bool success = result["success"] as bool;
      if(success) {
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  static Future<bool> updatePassword(String email, String password) async {
    final response = await MyHttpClient.post(
      path: URLs.updateSalaryPassword,
      data: {
        "email": email,
        "password": password
      },
    );
    final result = jsonDecode(response.body);
    log(result.toString());
    if(response.statusCode == HttpStatus.ok) {
      bool success = result["success"] as bool;
      if(success) {
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  static Future<bool> resetSalaryPassword(String oldPassword, String newPassword) async {
    final response = await MyHttpClient.post(
      path: URLs.resetSalaryPassword,
      data: {
        "old_password": oldPassword,
        "new_password": newPassword
      },
      isAuthenticated: true
    );
    final result = jsonDecode(response.body);
    log(result.toString());
    if(response.statusCode == HttpStatus.ok) {
      bool success = result["success"] as bool;
      if(success) {
        await logout();
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  static Future<bool> updateSalary(int id, String firstName, String lastName, String phone) async {
    final response = await MyHttpClient.post(
      path: URLs.updateSalary,
      data: {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
      },
      isAuthenticated: true
    );
    final result = jsonDecode(response.body);
    log(result.toString());
    if(response.statusCode == HttpStatus.ok) {
      bool success = result["success"] as bool;
      if(success) {
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  static Future<Otp> regenerateOtp(String email) async {
    final response = await MyHttpClient.post(
        path: URLs.regenerateSalaryOtp,
        data: {
          "email": email
        },
    );
    final result = jsonDecode(response.body);
    print(result);
    if(response.statusCode == HttpStatus.ok) {
      bool success = result["success"] as bool;
      if(success) {
        return Otp(
            result["otp"]["status"] as bool,
            result["otp"]["token"].toString(),
            result["otp"]["message"].toString()
        );
      }else{
        return Otp(
            false,
            "",
            ""
        );
      }
    }else{
      return Otp(
          false,
          "",
          ""
      );
    }
  }

  static bool isAuthenticated() {
    final authenticated = box.read(MyHttpClient.authenticated) ?? false;
    return authenticated;
  }

  static Future<Response> logout() async {
    final response = await MyHttpClient.post(
        path: URLs.logout,
        isAuthenticated: true
    );
    if(response.statusCode == HttpStatus.ok) {
      final result = jsonDecode(response.body);
      box.erase();
      TempSalary.temp = false;
      return Response(result["success"] as bool, result["message"]);
    }
    return Response(false, "Erreur");
  }

  static Future<bool> validateSteps(String stepsDate, int salaryId, int steps) async {
    final response = await MyHttpClient.post(
      path: URLs.validateSteps,
      data: {
        "steps_date": stepsDate,
        "salary_id": salaryId,
        "steps": steps,
      },
      isAuthenticated: true
    );
    final result = jsonDecode(response.body);
    log(result.toString());
    if(response.statusCode == HttpStatus.ok) {
      bool success = result["success"] as bool;
      if(success) {
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  static Future<bool> validateChallenge(int targetSteps, int salaryId, int challengeId) async {
    final response = await MyHttpClient.post(
        path: URLs.validateChallenge,
        data: {
          "salary_id": salaryId,
          "target_steps": targetSteps,
          "challenge_id": challengeId,
        },
        isAuthenticated: true
    );
    final result = jsonDecode(response.body);
    log(result.toString());
    if(response.statusCode == HttpStatus.ok) {
      bool success = result["success"] as bool;
      if(success) {
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

}