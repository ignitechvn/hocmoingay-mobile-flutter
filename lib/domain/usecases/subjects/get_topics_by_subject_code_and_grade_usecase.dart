import '../../../data/dto/bank_topic_dto.dart';
import '../../../domain/base/base_use_case.dart';
import '../../../domain/repositories/subjects_repository.dart';

class GetTopicsBySubjectCodeAndGradeUseCase
    implements BaseUseCase<List<BankTopicWithCountDto>, Map<String, String>> {
  final SubjectsRepository _subjectsRepository;

  GetTopicsBySubjectCodeAndGradeUseCase(this._subjectsRepository);

  @override
  Future<List<BankTopicWithCountDto>> call(Map<String, String> params) async {
    final subjectCode = params['subjectCode']!;
    final grade = params['grade']!;

    return await _subjectsRepository.getTopicsBySubjectCodeAndGrade(
      subjectCode,
      grade,
    );
  }
}
