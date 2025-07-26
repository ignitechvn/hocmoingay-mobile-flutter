import '../../../core/constants/classroom_status_constants.dart';
import '../../../data/dto/classroom_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_classroom_repository.dart';

class UpdateClassroomStatusParams {
  final String classroomId;
  final UpdateClassroomStatusDto dto;

  const UpdateClassroomStatusParams({
    required this.classroomId,
    required this.dto,
  });
}

class UpdateClassroomStatusUseCase
    extends BaseUseCase<ClassroomTeacherResponseDto, UpdateClassroomStatusParams> {
  final TeacherClassroomRepository _repository;

  UpdateClassroomStatusUseCase(this._repository);

  @override
  Future<ClassroomTeacherResponseDto> call(
    UpdateClassroomStatusParams params,
  ) async {
    return await _repository.updateClassroomStatus(
      params.classroomId,
      params.dto,
    );
  }
}
