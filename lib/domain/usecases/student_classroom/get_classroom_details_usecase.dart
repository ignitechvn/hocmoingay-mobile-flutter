import '../../base/base_use_case.dart';
import '../../repositories/student_classroom_repository.dart';
import '../../../data/dto/classroom_details_dto.dart';

class GetClassroomDetailsUseCase
    extends BaseUseCase<ClassroomDetailsStudentResponseDto, String> {
  final StudentClassroomRepository _repository;

  GetClassroomDetailsUseCase(this._repository);

  @override
  Future<ClassroomDetailsStudentResponseDto> call(String classroomId) async {
    return await _repository.getDetails(classroomId);
  }
}
