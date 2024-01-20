import 'package:lev_mobile/models/challenge_model.dart';

class Company {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? country;
  String? city;
  String? province;
  String? postcode;
  String? siret;
  String? domain;
  String? logo;
  int? stepLevs;
  List<Challenge> challenges;

  Company.dataFromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        name = json['name'] ?? "",
        email = json['email'] ?? "",
        phone = json['phone'] ?? "",
        address = json['address'] ?? "",
        country = json['country'] ?? "",
        city = json['city'] ?? "",
        province = json['province'] ?? "",
        postcode = json['postcode'] ?? "",
        siret = json['siret'] ?? "",
        domain = json['domain'] ?? "",
        logo = json['logo'] ?? "",
        stepLevs = json['step_levs'] ?? 0,
        challenges = (json['challenges'] != null)
            ? List.generate(
                (json["challenges"] as List).length,
                (index) => Challenge.dataFromJson(
                    (json["challenges"] as List)[index]
                )
              )
            : [];

}