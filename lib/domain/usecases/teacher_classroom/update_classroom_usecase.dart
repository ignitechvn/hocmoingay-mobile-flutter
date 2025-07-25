import '../../../data/dto/classroom_dto.dart';
import '../../../data/dto/teacher_classroom_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_classroom_repository.dart';

class UpdateClassroomUseCase
    extends BaseUseCase<ClassroomTeacherResponseDto, UpdateClassroomParams> {
  final TeacherClassroomRepository _repository;

  UpdateClassroomUseCase(this._repository);

  @override
  Future<ClassroomTeacherResponseDto> call(UpdateClassroomParams params) async {
    return await _repository.updateClassroom(params.classroomId, params.dto);
  }
}

class UpdateClassroomParams {
  final String classroomId;
  final UpdateClassroomDto dto;

  const UpdateClassroomParams({required this.classroomId, required this.dto});
}
