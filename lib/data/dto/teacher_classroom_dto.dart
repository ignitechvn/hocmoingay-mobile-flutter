// Schedule Item DTO for creating classroom
class ScheduleItemDto {
  final int dayOfWeek;
  final String startTime;
  final String endTime;

  const ScheduleItemDto({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleItemDto.fromJson(Map<String, dynamic> json) =>
      ScheduleItemDto(
        dayOfWeek: json['dayOfWeek'] as int,
        startTime: json['startTime'] as String,
        endTime: json['endTime'] as String,
      );

  Map<String, dynamic> toJson() => {
        'dayOfWeek': dayOfWeek,
        'startTime': startTime,
        'endTime': endTime,
      };
}

// Create Classroom DTO
class CreateClassroomDto {
  final String name;
  final String code;
  final String grade;
  final int? numberOfLessons;
  final String? startDate;
  final String? endDate;
  final List<ScheduleItemDto>? schedule;

  const CreateClassroomDto({
    required this.name,
    required this.code,
    required this.grade,
    this.numberOfLessons,
    this.startDate,
    this.endDate,
    this.schedule,
  });

  factory CreateClassroomDto.fromJson(Map<String, dynamic> json) =>
      CreateClassroomDto(
        name: json['name'] as String,
        code: json['code'] as String,
        grade: json['grade'] as String,
        numberOfLessons: json['numberOfLessons'] as int?,
        startDate: json['startDate'] as String?,
        endDate: json['endDate'] as String?,
        schedule: json['schedule'] != null
            ? (json['schedule'] as List<dynamic>)
                .map((e) => ScheduleItemDto.fromJson(e as Map<String, dynamic>))
                .toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
        'grade': grade,
        if (numberOfLessons != null) 'numberOfLessons': numberOfLessons,
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (schedule != null) 'schedule': schedule!.map((e) => e.toJson()).toList(),
      };
}
