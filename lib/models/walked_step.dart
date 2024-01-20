class WalkedStep {
  int id;
  String stepsDate;
  int steps;
  int salaryId;

  WalkedStep.dataFromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        stepsDate = json['steps_date'] ?? "",
        steps = json['steps'] ?? 0,
        salaryId = json['salary_id'] ?? 0;
}