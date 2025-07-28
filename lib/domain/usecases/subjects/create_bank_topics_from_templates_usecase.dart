import '../../../data/dto/bank_topic_dto.dart';
import '../../../data/dto/create_bank_topics_from_templates_dto.dart';
import '../../../domain/base/base_use_case.dart';
import '../../../domain/repositories/subjects_repository.dart';

class CreateBankTopicsFromTemplatesUseCase
    implements
        BaseUseCase<
          List<BankTopicResponseDto>,
          CreateBankTopicsFromTemplatesDto
        > {
  final SubjectsRepository _subjectsRepository;

  CreateBankTopicsFromTemplatesUseCase(this._subjectsRepository);

  @override
  Future<List<BankTopicResponseDto>> call(
    CreateBankTopicsFromTemplatesDto dto,
  ) async {
    return await _subjectsRepository.createBankTopicsFromTemplates(dto);
  }
}
