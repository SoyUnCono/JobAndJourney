// ignore_for_file: file_names

class DayRecord {
  String date;
  int hours;
  double salary;
  String job;
  final bool hasOvertime;
  final double? overtimeRate;
  final int? overtimeHours;

  DayRecord({
    required this.date,
    required this.hours,
    required this.salary,
    required this.job,
    required this.hasOvertime,
    this.overtimeRate,
    this.overtimeHours,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'hours': hours,
      'salary': salary,
      'job': job,
      'hasOvertime': hasOvertime,
      'overtimeRate': overtimeRate,
      'overtimeHours': overtimeHours,
    };
  }

  factory DayRecord.fromJson(Map<String, dynamic> json) {
    return DayRecord(
      date: json['date'],
      hours: json['hours'],
      salary: json['salary'],
      job: json['job'],
      hasOvertime: json['hasOvertime'] ?? false,
      overtimeRate: json['overtimeRate'],
      overtimeHours: json['overtimeHours'],
    );
  }
}