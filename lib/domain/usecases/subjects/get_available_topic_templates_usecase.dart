import '../../../data/dto/topic_template_dto.dart';
import '../../../domain/base/base_use_case.dart';
import '../../../domain/repositories/subjects_repository.dart';

class GetAvailableTopicTemplatesUseCase
    implements BaseUseCase<List<TopicTemplateResponseDto>, String> {
  final SubjectsRepository _subjectsRepository;

  GetAvailableTopicTemplatesUseCase(this._subjectsRepository);

  @override
  Future<List<TopicTemplateResponseDto>> call(String subjectId) async {
    return await _subjectsRepository.getAvailableTopicTemplates(subjectId);
  }
} 