class CreateBankTopicsFromTemplatesDto {
  final String subjectId;
  final List<String> topicTemplateIds;

  CreateBankTopicsFromTemplatesDto({
    required this.subjectId,
    required this.topicTemplateIds,
  });

  factory CreateBankTopicsFromTemplatesDto.fromJson(Map<String, dynamic> json) {
    return CreateBankTopicsFromTemplatesDto(
      subjectId: json['subjectId'] as String,
      topicTemplateIds: List<String>.from(json['topicTemplateIds'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {'subjectId': subjectId, 'topicTemplateIds': topicTemplateIds};
  }
}
