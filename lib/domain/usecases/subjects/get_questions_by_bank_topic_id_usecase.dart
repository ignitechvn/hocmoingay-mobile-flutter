import '../../../data/dto/bank_question_dto.dart';
import '../../../domain/base/base_use_case.dart';
import '../../../domain/repositories/subjects_repository.dart';

class GetQuestionsByBankTopicIdUseCase
    implements BaseUseCase<List<BankQuestionResponseDto>, String> {
  final SubjectsRepository _subjectsRepository;

  GetQuestionsByBankTopicIdUseCase(this._subjectsRepository);

  @override
  Future<List<BankQuestionResponseDto>> call(String bankTopicId) async {
    return await _subjectsRepository.getQuestionsByBankTopicId(bankTopicId);
  }
}
