// Subject Response DTO
class SubjectResponseDto {
  final String id;
  final String code;
  final String name;
  final String? description;
  final String grade;
  final bool isActive;
  final String createdDate;
  final String? updateDate;

  const SubjectResponseDto({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.grade,
    required this.isActive,
    required this.createdDate,
    this.updateDate,
  });

  factory SubjectResponseDto.fromJson(Map<String, dynamic> json) {
    return SubjectResponseDto(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      grade: json['grade'] ?? '',
      isActive: json['isActive'] ?? false,
      createdDate: json['createdDate'] ?? '',
      updateDate: json['updateDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'grade': grade,
      'isActive': isActive,
      'createdDate': createdDate,
      'updateDate': updateDate,
    };
  }
}

// Create Subject DTO
class CreateSubjectDto {
  final String code;
  final String grade;
  final String name;
  final String? description;

  const CreateSubjectDto({
    required this.code,
    required this.grade,
    required this.name,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'grade': grade,
      'name': name,
      if (description != null) 'description': description,
    };
  }
}
