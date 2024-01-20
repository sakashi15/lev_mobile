import 'package:lev_mobile/models/company_model.dart';
import 'package:lev_mobile/models/walked_step.dart';

class Salary {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? password;
  int? companyId;
  Company? company;
  double? lev;
  int? walkingSteps;
  String? lastWalkedStepsDate;
  List<WalkedStep>? walkedSteps;
  List<int>? completedChallenges;

  Salary.init(
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.password,
      this.companyId
  );

  Salary.login(this.email, this.password);

  Map<String, dynamic> loginToJson() => {
    "login": email,
    "password": password,
  };

  Map<String, dynamic> registerToJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "username": email,
    "phone": phone,
    "password": password,
    "company_id": companyId
  };

  Salary.dataFromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        firstName = json['first_name'] ?? "",
        lastName = json['last_name'] ?? "",
        email = json['email'] ?? "",
        phone = json['phone'] ?? "",
        password = json['password'] ?? "",
        lev = (json['levs'] != null) ? double.tryParse(json['levs'].toString()) : 0.0,
        walkingSteps = (json['walking_steps'] != null) ? int.parse(json['walking_steps'].toString()) : 0,
        lastWalkedStepsDate = json['last_walked_steps_date'] ?? "",
        companyId = json["company"]['id'] ?? "",
        walkedSteps = (json['walked_steps'] != null)
            ? List.generate(
            (json["walked_steps"] as List).length,
                (index) => WalkedStep.dataFromJson(
                (json["walked_steps"] as List)[index]
            )
        )
            : [],
        completedChallenges = (json['completed_challenges'] != null)
            ? List.generate(
            (json["completed_challenges"] as List).length,
                (index) => (json["completed_challenges"] as List)[index] as int
        )
            : [],
        company = Company.dataFromJson(json["company"]);


}

class TempSalary {
  static bool temp = false;
  static late int id;
  static late String token;
  static late String fullName;
  static late String email;
  static late String phone;
}