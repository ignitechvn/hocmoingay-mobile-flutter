import '../../datasources/api/subjects_api.dart';
import '../../dto/subject_dto.dart';
import '../../dto/bank_topic_dto.dart';
import '../../dto/topic_template_dto.dart';
import '../../dto/create_bank_topics_from_templates_dto.dart';
import '../../dto/bank_question_dto.dart';
import '../../../domain/repositories/subjects_repository.dart';

class SubjectsRepositoryImpl implements SubjectsRepository {
  final SubjectsApi _subjectsApi;

  SubjectsRepositoryImpl(this._subjectsApi);

  @override
  Future<List<SubjectResponseDto>> getAllSubjects() async {
    return await _subjectsApi.getAllSubjects();
  }

  @override
  Future<SubjectResponseDto> createSubject(CreateSubjectDto dto) async {
    return await _subjectsApi.createSubject(dto);
  }

  @override
  Future<List<BankTopicWithCountDto>> getTopicsBySubjectCodeAndGrade(
    String subjectCode,
    String grade,
  ) async {
    return await _subjectsApi.getTopicsBySubjectCodeAndGrade(
      subjectCode,
      grade,
    );
  }

  @override
  Future<List<TopicTemplateResponseDto>> getAvailableTopicTemplates(
    String subjectId,
  ) async {
    return await _subjectsApi.getAvailableTopicTemplates(subjectId);
  }

  @override
  Future<List<BankTopicResponseDto>> createBankTopicsFromTemplates(
    CreateBankTopicsFromTemplatesDto dto,
  ) async {
    return await _subjectsApi.createBankTopicsFromTemplates(dto);
  }

  @override
  Future<List<BankQuestionResponseDto>> getQuestionsByBankTopicId(
    String bankTopicId,
  ) async {
    return await _subjectsApi.getQuestionsByBankTopicId(bankTopicId);
  }

  @override
  Future<void> deleteBankQuestion(String questionId) async {
    return await _subjectsApi.deleteBankQuestion(questionId);
  }
}
