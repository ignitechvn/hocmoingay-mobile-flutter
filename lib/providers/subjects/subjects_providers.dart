import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/api/subjects_api.dart';
import '../../data/dto/subject_dto.dart';
import '../../data/repositories/subjects/subjects_repository_impl.dart';
import '../../domain/repositories/subjects_repository.dart';
import '../../domain/usecases/subjects/get_all_subjects_usecase.dart';
import '../../domain/usecases/subjects/create_subject_usecase.dart';
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

// Data Provider
final subjectsProvider = FutureProvider<List<SubjectResponseDto>>((ref) async {
  final useCase = ref.watch(getAllSubjectsUseCaseProvider);
  return await useCase(null);
});
