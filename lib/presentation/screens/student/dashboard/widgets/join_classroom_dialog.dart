import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../data/dto/classroom_lookup_dto.dart';
import '../../../../../providers/api/api_providers.dart';
import '../../../../../core/constants/classroom_constants.dart';
import '../../../../../core/constants/grade_constants.dart';
import '../../../../../core/constants/subject_constants.dart';

class JoinClassroomDialog extends ConsumerStatefulWidget {
  const JoinClassroomDialog({super.key});

  @override
  ConsumerState<JoinClassroomDialog> createState() =>
      _JoinClassroomDialogState();
}

class _JoinClassroomDialogState extends ConsumerState<JoinClassroomDialog> {
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isJoining = false;
  ClassroomPreviewResponseDto? _classroomPreview;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Tham gia lớp học',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Search field with icon button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _codeController,
                            label: 'Mã lớp học',
                            hint: 'Nhập mã lớp học',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mã lớp học';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 48, // Square button
                          height: 48, // Same height as AppTextField
                          child: IconButton(
                            onPressed: _isLoading ? null : _searchClassroom,
                            icon:
                                _isLoading
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Icon(Icons.search),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Classroom preview
              if (_classroomPreview != null) ...[
                const SizedBox(height: 20),
                _buildClassroomPreview(),
              ],

              const SizedBox(height: 16),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Close button
                  AppButton(
                    text: 'Đóng',
                    type: AppButtonType.secondary,
                    onPressed: () => Navigator.of(context).pop(),
                    isFullWidth: false,
                  ),
                  const SizedBox(width: 12),
                  // Join button
                  AppButton(
                    text: _isJoining ? 'Đang tham gia...' : 'Tham gia',
                    onPressed:
                        _isJoining || _classroomPreview == null
                            ? null
                            : _joinClassroom,
                    isLoading: _isJoining,
                    isFullWidth: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassroomPreview() {
    final classroom = _classroomPreview!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          // Tên lớp
          _buildInfoRow('Tên lớp', classroom.name),
          const SizedBox(height: 12),

          // Giáo viên
          _buildInfoRow('Giáo viên', classroom.teacher.fullName),
          const SizedBox(height: 12),

          // Lớp
          _buildInfoRow('Lớp', EGradeLevel.fromString(classroom.grade).label),
          const SizedBox(height: 12),

          // Môn
          _buildInfoRow(
            'Môn',
            SubjectLabels.getLabel(ESubjectCode.fromString(classroom.code)),
          ),
          const SizedBox(height: 12),

          // Trạng thái
          _buildInfoRow('Trạng thái', 'Đang tuyển sinh'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _searchClassroom() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _classroomPreview = null;
    });

    try {
      final classroom = await ref
          .read(studentClassroomApiProvider)
          .lookupClassroom(_codeController.text.trim());

      setState(() {
        _classroomPreview = classroom;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không tìm thấy lớp học với mã: ${_codeController.text}',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _joinClassroom() async {
    if (_classroomPreview == null) return;

    setState(() {
      _isJoining = true;
    });

    try {
      await ref
          .read(studentClassroomApiProvider)
          .joinClassroom(_classroomPreview!.joinCode);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tham gia lớp học thành công!'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tham gia lớp học thất bại. Vui lòng thử lại.'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        _isJoining = false;
      });
    }
  }
}
