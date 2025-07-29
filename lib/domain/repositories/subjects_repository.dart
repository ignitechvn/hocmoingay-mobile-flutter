import '../../data/dto/subject_dto.dart';
import '../../data/dto/bank_topic_dto.dart';
import '../../data/dto/topic_template_dto.dart';
import '../../data/dto/create_bank_topics_from_templates_dto.dart';
import '../../data/dto/bank_question_dto.dart';

abstract class SubjectsRepository {
  Future<List<SubjectResponseDto>> getAllSubjects();
  Future<SubjectResponseDto> createSubject(CreateSubjectDto dto);
  Future<List<BankTopicWithCountDto>> getTopicsBySubjectCodeAndGrade(
    String subjectCode,
    String grade,
  );

  Future<List<TopicTemplateResponseDto>> getAvailableTopicTemplates(
    String subjectId,
  );

  Future<List<BankTopicResponseDto>> createBankTopicsFromTemplates(
    CreateBankTopicsFromTemplatesDto dto,
  );

  Future<List<BankQuestionResponseDto>> getQuestionsByBankTopicId(
    String bankTopicId,
  );

  Future<void> deleteBankQuestion(String questionId);
}
