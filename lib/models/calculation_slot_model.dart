
class CalculationSlot {
  String startTime;
  String endTime;
  String weekday;

  CalculationSlot.dataFromJson(Map<String, dynamic> json)
      : startTime = json['start_time'] ?? "",
        endTime = json['end_time'] ?? "",
        weekday = json['weekday'] ?? "";
}