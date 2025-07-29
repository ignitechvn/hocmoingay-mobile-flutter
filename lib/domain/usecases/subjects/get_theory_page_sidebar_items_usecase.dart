import '../../base/base_use_case.dart';
import '../../../data/dto/bank_theory_page_dto.dart';
import '../../repositories/subjects_repository.dart';

class GetTheoryPageSidebarItemsUseCase
    implements BaseUseCase<BankTheoryPageSidebarResponseDto, String> {
  final SubjectsRepository _subjectsRepository;

  GetTheoryPageSidebarItemsUseCase(this._subjectsRepository);

  @override
  Future<BankTheoryPageSidebarResponseDto> call(String bankTopicId) async {
    return await _subjectsRepository.getTheoryPageSidebarItems(bankTopicId);
  }
}
