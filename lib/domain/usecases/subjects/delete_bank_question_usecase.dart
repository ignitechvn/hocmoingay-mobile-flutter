import '../../base/base_use_case.dart';
import '../../repositories/subjects_repository.dart';

class DeleteBankQuestionUseCase implements BaseUseCase<void, String> {
  final SubjectsRepository _repository;

  DeleteBankQuestionUseCase(this._repository);

  @override
  Future<void> call(String questionId) async {
    return await _repository.deleteBankQuestion(questionId);
  }
}
