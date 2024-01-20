

import 'package:lev_mobile/models/response_model.dart';
import 'package:lev_mobile/models/salary_model.dart';
import 'package:lev_mobile/services/salary_service.dart';

class SalaryController {

  static Future<Response> authenticateSalary(String email, String password, bool rememberMe) async {
    Salary salary = Salary.login(
      email,
      password,
    );
    Response response = await SalaryService.authenticate(salary, rememberMe);
    return response;
  }

  static Future<dynamic> isAuthenticated() async {
    bool authenticated = await SalaryService.isAuthenticated();
    return authenticated;
  }

  static Future<Response> logout() async {
    Response response = await SalaryService.logout();
    return response;
  }

}