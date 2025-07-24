import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/student_classroom_repository_impl.dart';
import '../../domain/entities/classroom.dart';
import '../../domain/usecases/student_classroom/get_student_classrooms_usecase.dart';
import '../../domain/usecases/student_classroom/get_classroom_details_usecase.dart';
import '../../data/dto/classroom_details_dto.dart';
import '../../core/constants/app_constants.dart';
import '../api/api_providers.dart';

// Repository Provider
final studentClassroomRepositoryProvider =
    Provider<StudentClassroomRepositoryImpl>((ref) {
      final api = ref.watch(studentClassroomApiProvider);
      return StudentClassroomRepositoryImpl(api);
    });

// Use Case Providers
final getStudentClassroomsUseCaseProvider =
    Provider<GetStudentClassroomsUseCase>((ref) {
      final repository = ref.watch(studentClassroomRepositoryProvider);
      return GetStudentClassroomsUseCase(repository);
    });

final getClassroomDetailsUseCaseProvider =
    Provider<GetClassroomDetailsUseCase>((ref) {
      final repository = ref.watch(studentClassroomRepositoryProvider);
      return GetClassroomDetailsUseCase(repository);
    });

// Real API Providers
final studentClassroomsProvider = FutureProvider<StudentClassrooms>((
  ref,
) async {
  final useCase = ref.watch(getStudentClassroomsUseCaseProvider);
  return await useCase(null);
});

final classroomDetailsProvider = FutureProvider.family<ClassroomDetailsStudentResponseDto, String>((
  ref,
  classroomId,
) async {
  final useCase = ref.watch(getClassroomDetailsUseCaseProvider);
  return await useCase(classroomId);
});


