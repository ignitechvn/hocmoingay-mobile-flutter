import '../../../data/dto/teacher_classroom_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_classroom_repository.dart';

class GetClassroomDetailsUseCase
    extends BaseUseCase<ClassroomDetailsTeacherResponseDto, String> {
  final TeacherClassroomRepository _repository;

  GetClassroomDetailsUseCase(this._repository);

  @override
  Future<ClassroomDetailsTeacherResponseDto> call(String classroomId) async {
    return await _repository.getClassroomDetails(classroomId);
  }
}
