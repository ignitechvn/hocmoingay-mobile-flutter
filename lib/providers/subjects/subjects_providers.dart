import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/api/subjects_api.dart';
import '../../data/dto/subject_dto.dart';
import '../../data/dto/bank_topic_dto.dart';
import '../../data/repositories/subjects/subjects_repository_impl.dart';
import '../../domain/repositories/subjects_repository.dart';
import '../../domain/usecases/subjects/get_all_subjects_usecase.dart';
import '../../domain/usecases/subjects/create_subject_usecase.dart';
import '../../domain/usecases/subjects/get_topics_by_subject_code_and_grade_usecase.dart';
import '../../domain/usecases/subjects/get_available_topic_templates_usecase.dart';
import '../../domain/usecases/subjects/create_bank_topics_from_templates_usecase.dart';
import '../../domain/usecases/subjects/get_questions_by_bank_topic_id_usecase.dart';
import '../../data/dto/topic_template_dto.dart';
import '../../data/dto/create_bank_topics_from_templates_dto.dart';
import '../../data/dto/bank_question_dto.dart';
import '../api/api_providers.dart';

// API Provider
final subjectsApiProvider = Provider<SubjectsApi>((ref) {
  final baseApiService = ref.watch(authenticatedBaseApiServiceProvider);
  return SubjectsApi(baseApiService);
});

// Repository Provider
final subjectsRepositoryProvider = Provider<SubjectsRepository>((ref) {
  final api = ref.watch(subjectsApiProvider);
  return SubjectsRepositoryImpl(api);
});

// Use Case Provider
final getAllSubjectsUseCaseProvider = Provider<GetAllSubjectsUseCase>((ref) {
  final repository = ref.watch(subjectsRepositoryProvider);
  return GetAllSubjectsUseCase(repository);
});

final createSubjectUseCaseProvider = Provider<CreateSubjectUseCase>((ref) {
  final repository = ref.watch(subjectsRepositoryProvider);
  return CreateSubjectUseCase(repository);
});

final getTopicsBySubjectCodeAndGradeUseCaseProvider =
    Provider<GetTopicsBySubjectCodeAndGradeUseCase>((ref) {
      final repository = ref.watch(subjectsRepositoryProvider);
      return GetTopicsBySubjectCodeAndGradeUseCase(repository);
});

final getAvailableTopicTemplatesUseCaseProvider =
    Provider<GetAvailableTopicTemplatesUseCase>((ref) {
      final repository = ref.watch(subjectsRepositoryProvider);
      return GetAvailableTopicTemplatesUseCase(repository);
});

final createBankTopicsFromTemplatesUseCaseProvider =
    Provider<CreateBankTopicsFromTemplatesUseCase>((ref) {
      final repository = ref.watch(subjectsRepositoryProvider);
      return CreateBankTopicsFromTemplatesUseCase(repository);
});

final getQuestionsByBankTopicIdUseCaseProvider =
    Provider<GetQuestionsByBankTopicIdUseCase>((ref) {
      final repository = ref.watch(subjectsRepositoryProvider);
      return GetQuestionsByBankTopicIdUseCase(repository);
});

// Data Provider
final subjectsProvider = FutureProvider<List<SubjectResponseDto>>((ref) async {
  final useCase = ref.watch(getAllSubjectsUseCaseProvider);
  return await useCase(null);
});

final topicsBySubjectProvider =
    FutureProvider.family<List<BankTopicWithCountDto>, Map<String, String>>((
      ref,
      params,
    ) async {
      final useCase = ref.read(getTopicsBySubjectCodeAndGradeUseCaseProvider);
      return await useCase(params);
    });

// Provider ổn định hơn để tránh rebuild liên tục
final stableTopicsBySubjectProvider = Provider.family<AsyncValue<List<BankTopicWithCountDto>>, Map<String, String>>((ref, params) {
  return ref.watch(topicsBySubjectProvider(params));
});

// Topic Templates Provider
final topicTemplatesProvider =
    FutureProvider.family<List<TopicTemplateResponseDto>, String>((ref, subjectId) async {
      final useCase = ref.read(getAvailableTopicTemplatesUseCaseProvider);
      return await useCase(subjectId);
    });

// Bank Topic Questions Provider
final bankTopicQuestionsProvider =
    FutureProvider.family<List<BankQuestionResponseDto>, String>((ref, bankTopicId) async {
      final useCase = ref.read(getQuestionsByBankTopicIdUseCaseProvider);
      return await useCase(bankTopicId);
    });
