import 'package:lev_mobile/models/company_model.dart';

class Challenge {
  int? id;
  String? title;
  String? description;
  int? steps;
  String? logo;
  String? startDate;
  String? endDate;
  List<Company> companies;

  Challenge.dataFromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        title = json['title'] ?? "",
        description = json['description'] ?? "",
        steps = json['steps'] ?? 0,
        logo = json['logo'] ?? "",
        startDate = json['start_date'] ?? "",
        endDate = json['end_date'] ?? "",
        companies = (json['companies'] != null)
            ? List.generate(
            (json["companies"] as List).length,
                (index) => Company.dataFromJson(
                (json["companies"] as List)[index]
            )
        )
            : [];

}