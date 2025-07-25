import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/api/statistical_api.dart';
import '../../data/dto/statistical_dto.dart';
import '../../data/repositories/statistical/statistical_repository_impl.dart';
import '../../domain/repositories/statistical_repository.dart';
import '../../domain/usecases/statistical/get_classroom_overview_usecase.dart';
import '../../domain/usecases/statistical/get_student_progress_report_usecase.dart';
import '../../domain/usecases/statistical/get_chapter_report_usecase.dart';
import '../../domain/usecases/statistical/get_practice_set_report_usecase.dart';
import '../../domain/usecases/statistical/get_exam_report_usecase.dart';
import '../api/api_providers.dart';

// API Provider
final statisticalApiProvider = Provider<StatisticalApi>((ref) {
  final apiService = ref.watch(authenticatedBaseApiServiceProvider);
  return StatisticalApi(apiService);
});

// Repository Provider
final statisticalRepositoryProvider = Provider<StatisticalRepository>((ref) {
  final api = ref.watch(statisticalApiProvider);
  return StatisticalRepositoryImpl(api);
});

// Use Case Provider
final getClassroomOverviewUseCaseProvider =
    Provider<GetClassroomOverviewUseCase>((ref) {
      final repository = ref.watch(statisticalRepositoryProvider);
      return GetClassroomOverviewUseCase(repository);
    });

final getStudentProgressReportUseCaseProvider =
    Provider<GetStudentProgressReportUseCase>((ref) {
      final repository = ref.watch(statisticalRepositoryProvider);
      return GetStudentProgressReportUseCase(repository);
    });

final getChapterReportUseCaseProvider = Provider<GetChapterReportUseCase>((
  ref,
) {
  final repository = ref.watch(statisticalRepositoryProvider);
  return GetChapterReportUseCase(repository);
});

final getPracticeSetReportUseCaseProvider =
    Provider<GetPracticeSetReportUseCase>((ref) {
      final repository = ref.watch(statisticalRepositoryProvider);
      return GetPracticeSetReportUseCase(repository);
    });

final getExamReportUseCaseProvider = Provider<GetExamReportUseCase>((ref) {
  final repository = ref.watch(statisticalRepositoryProvider);
  return GetExamReportUseCase(repository);
});

// Custom key class for student progress report
class StudentProgressReportKey {
  final String classroomId;
  final String studentId;

  const StudentProgressReportKey({
    required this.classroomId,
    required this.studentId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentProgressReportKey &&
          runtimeType == other.runtimeType &&
          classroomId == other.classroomId &&
          studentId == other.studentId;

  @override
  int get hashCode => classroomId.hashCode ^ studentId.hashCode;

  @override
  String toString() =>
      'StudentProgressReportKey(classroomId: $classroomId, studentId: $studentId)';
}

// Data Provider
final classroomOverviewProvider =
    FutureProvider.family<ClassroomOverviewResponseDto, String>((
      ref,
      classroomId,
    ) async {
      final useCase = ref.watch(getClassroomOverviewUseCaseProvider);
      return await useCase(classroomId);
    });

final studentProgressReportProvider =
    FutureProvider.family<StudentProgressReportDto, StudentProgressReportKey>((
      ref,
      key,
    ) async {
      final useCase = ref.watch(getStudentProgressReportUseCaseProvider);
      return await useCase({
        'classroomId': key.classroomId,
        'studentId': key.studentId,
      });
    });

final chapterReportProvider = FutureProvider.family<ChapterReportDto, String>((
  ref,
  chapterId,
) async {
  final useCase = ref.watch(getChapterReportUseCaseProvider);
  return await useCase(chapterId);
});

final practiceSetReportProvider =
    FutureProvider.family<PracticeSetReportDto, String>((
      ref,
      practiceSetId,
    ) async {
      final useCase = ref.watch(getPracticeSetReportUseCaseProvider);
      return await useCase(practiceSetId);
    });

final examReportProvider = FutureProvider.family<ExamReportDto, String>((
  ref,
  examId,
) async {
  final useCase = ref.watch(getExamReportUseCaseProvider);
  return await useCase(examId);
});
