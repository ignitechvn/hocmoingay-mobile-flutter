import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/api/teacher_classroom_api.dart';
import '../../data/dto/teacher_classroom_dto.dart';
import '../../data/dto/chapter_dto.dart';
import '../../data/repositories/teacher_classroom/teacher_classroom_repository_impl.dart';
import '../../domain/repositories/teacher_classroom_repository.dart';
import '../../domain/usecases/teacher_classroom/get_teacher_classrooms_usecase.dart';
import '../../domain/usecases/teacher_classroom/create_classroom_usecase.dart';
import '../../domain/usecases/teacher_classroom/get_classroom_details_usecase.dart';
import '../../domain/usecases/teacher_classroom/get_approved_students_usecase.dart';
import '../../domain/usecases/teacher_classroom/remove_student_usecase.dart';
import '../../domain/usecases/teacher_classroom/get_pending_students_usecase.dart';
import '../../domain/usecases/teacher_classroom/approve_student_usecase.dart';
import '../../domain/usecases/teacher_classroom/reject_student_usecase.dart';
import '../../domain/usecases/teacher_classroom/get_teacher_chapters_usecase.dart';
import '../../providers/api/api_providers.dart';

// API Provider
final teacherClassroomApiProvider = Provider<TeacherClassroomApi>((ref) {
  final baseApiService = ref.watch(authenticatedBaseApiServiceProvider);
  return TeacherClassroomApi(baseApiService);
});

// Repository Provider
final teacherClassroomRepositoryProvider = Provider<TeacherClassroomRepository>(
  (ref) {
    final api = ref.watch(teacherClassroomApiProvider);
    return TeacherClassroomRepositoryImpl(api);
  },
);

// Use Case Providers
final getTeacherClassroomsUseCaseProvider =
    Provider<GetTeacherClassroomsUseCase>((ref) {
      final repository = ref.watch(teacherClassroomRepositoryProvider);
      return GetTeacherClassroomsUseCase(repository);
    });

final createClassroomUseCaseProvider = Provider<CreateClassroomUseCase>((ref) {
  final repository = ref.watch(teacherClassroomRepositoryProvider);
  return CreateClassroomUseCase(repository);
});

final getClassroomDetailsUseCaseProvider = Provider<GetClassroomDetailsUseCase>(
  (ref) {
    final repository = ref.watch(teacherClassroomRepositoryProvider);
    return GetClassroomDetailsUseCase(repository);
  },
);

final getApprovedStudentsUseCaseProvider = Provider<GetApprovedStudentsUseCase>(
  (ref) {
    final repository = ref.watch(teacherClassroomRepositoryProvider);
    return GetApprovedStudentsUseCase(repository);
  },
);

final removeStudentUseCaseProvider = Provider<RemoveStudentUseCase>((ref) {
  final repository = ref.watch(teacherClassroomRepositoryProvider);
  return RemoveStudentUseCase(repository);
});

final getPendingStudentsUseCaseProvider = Provider<GetPendingStudentsUseCase>((
  ref,
) {
  final repository = ref.watch(teacherClassroomRepositoryProvider);
  return GetPendingStudentsUseCase(repository);
});

final approveStudentUseCaseProvider = Provider<ApproveStudentUseCase>((ref) {
  final repository = ref.watch(teacherClassroomRepositoryProvider);
  return ApproveStudentUseCase(repository);
});

final rejectStudentUseCaseProvider = Provider<RejectStudentUseCase>((ref) {
  final repository = ref.watch(teacherClassroomRepositoryProvider);
  return RejectStudentUseCase(repository);
});

final getTeacherChaptersUseCaseProvider = Provider<GetTeacherChaptersUseCase>((ref) {
  final repository = ref.watch(teacherClassroomRepositoryProvider);
  return GetTeacherChaptersUseCase(repository);
});

// Data Providers
final teacherClassroomsProvider = FutureProvider((ref) async {
  final useCase = ref.watch(getTeacherClassroomsUseCaseProvider);
  return await useCase(null);
});

final teacherClassroomDetailsProvider =
    FutureProvider.family<ClassroomDetailsTeacherResponseDto, String>((
      ref,
      classroomId,
    ) async {
      final useCase = ref.watch(getClassroomDetailsUseCaseProvider);
      return await useCase(classroomId);
    });

final approvedStudentsProvider =
    FutureProvider.family<List<StudentResponseDto>, String>((
      ref,
      classroomId,
    ) async {
      final useCase = ref.watch(getApprovedStudentsUseCaseProvider);
      return await useCase(classroomId);
    });

final pendingStudentsProvider =
    FutureProvider.family<List<PendingStudentResponseDto>, String>((
      ref,
      classroomId,
    ) async {
      final useCase = ref.watch(getPendingStudentsUseCaseProvider);
      return await useCase(classroomId);
    });

final teacherChaptersProvider =
    FutureProvider.family<TeacherChapterResponseListDto, String>((
      ref,
      classroomId,
    ) async {
      final useCase = ref.watch(getTeacherChaptersUseCaseProvider);
      return await useCase(classroomId);
    });
