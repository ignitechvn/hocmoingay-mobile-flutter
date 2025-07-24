import '../../../data/dto/teacher_classroom_dto.dart';
import '../../../data/dto/classroom_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_classroom_repository.dart';

class CreateClassroomUseCase
    extends BaseUseCase<ClassroomTeacherResponseDto, CreateClassroomDto> {
  final TeacherClassroomRepository _repository;

  CreateClassroomUseCase(this._repository);

  @override
  Future<ClassroomTeacherResponseDto> call(CreateClassroomDto params) async {
    return await _repository.createClassroom(params);
  }
}
