class TopicTemplateResponseDto {
  final String id;
  final String name;
  final String? description;
  final String subjectCode;
  final List<String> gradeLevels;
  final String? parentId;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;

  TopicTemplateResponseDto({
    required this.id,
    required this.name,
    this.description,
    required this.subjectCode,
    required this.gradeLevels,
    this.parentId,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TopicTemplateResponseDto.fromJson(Map<String, dynamic> json) {
    return TopicTemplateResponseDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      subjectCode: json['subjectCode'] as String,
      gradeLevels: List<String>.from(json['gradeLevels'] as List),
      parentId: json['parentId'] as String?,
      order: json['order'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'subjectCode': subjectCode,
      'gradeLevels': gradeLevels,
      'parentId': parentId,
      'order': order,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
} 