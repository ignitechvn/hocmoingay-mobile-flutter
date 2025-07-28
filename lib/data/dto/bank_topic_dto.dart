class BankTopicResponseDto {
  final String id;
  final String title;
  final String? description;
  final int order;
  final String? ownerId;
  final String subjectId;

  BankTopicResponseDto({
    required this.id,
    required this.title,
    this.description,
    required this.order,
    this.ownerId,
    required this.subjectId,
  });

  factory BankTopicResponseDto.fromJson(Map<String, dynamic> json) {
    return BankTopicResponseDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      order: json['order'] as int,
      ownerId: json['ownerId'] as String?,
      subjectId: json['subjectId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'order': order,
      'ownerId': ownerId,
      'subjectId': subjectId,
    };
  }
}

class BankTopicWithCountDto extends BankTopicResponseDto {
  final int questionCount;

  BankTopicWithCountDto({
    required super.id,
    required super.title,
    super.description,
    required super.order,
    super.ownerId,
    required super.subjectId,
    required this.questionCount,
  });

  factory BankTopicWithCountDto.fromJson(Map<String, dynamic> json) {
    return BankTopicWithCountDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      order: json['order'] as int,
      ownerId: json['ownerId'] as String?,
      subjectId: json['subjectId'] as String,
      questionCount: json['questionCount'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), 'questionCount': questionCount};
  }
}
