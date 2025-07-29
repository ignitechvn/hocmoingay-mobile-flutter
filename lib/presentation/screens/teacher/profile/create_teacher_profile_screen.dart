import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/subject_constants.dart';
import '../../../../core/constants/classroom_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../data/dto/teacher_profile_dto.dart';
import '../../../../providers/teacher_profile/teacher_profile_providers.dart';

class CreateTeacherProfileScreen extends ConsumerStatefulWidget {
  final TeacherProfileResponseDto? profile;
  final bool isEdit;
  const CreateTeacherProfileScreen({
    super.key,
    this.profile,
    this.isEdit = false,
  });

  @override
  ConsumerState<CreateTeacherProfileScreen> createState() =>
      _CreateTeacherProfileScreenState();
}

class _CreateTeacherProfileScreenState
    extends ConsumerState<CreateTeacherProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _universityController = TextEditingController();
  final _majorController = TextEditingController();
  final _experienceController = TextEditingController();
  final _bioController = TextEditingController();
  final _websiteController = TextEditingController();

  int? _graduationYear;
  int? _yearsOfTeaching;
  List<ESubjectCode> _selectedSubjects = [];
  Degree? _selectedDegree;

  bool _isLoading = false;

  final List<ESubjectCode> _subjects = ESubjectCode.values.toList();

  // Certifications
  final List<Map<String, dynamic>> _certifications = [];

  // Achievements
  final List<Map<String, dynamic>> _achievements = [];

  @override
  void initState() {
    super.initState();
    if (widget.profile != null) {
      _prefillForm(widget.profile!);
    }
  }

  void _prefillForm(TeacherProfileResponseDto profile) {
    _universityController.text = profile.university ?? '';
    _majorController.text = profile.major ?? '';
    _experienceController.text = profile.experienceDescription ?? '';
    _bioController.text = profile.bio ?? '';
    _websiteController.text = profile.personalWebsite ?? '';
    _graduationYear = profile.graduationYear;
    _yearsOfTeaching = profile.yearsOfTeaching;
    _selectedDegree = profile.degree != null
        ? Degree.values.firstWhere(
            (d) => d.name == profile.degree,
            orElse: () => Degree.bachelor,
          )
        : null;
    _selectedSubjects =
        profile.subjects
            ?.map((s) => ESubjectCode.fromString(s.subject))
            .toList() ??
        [];

    // Prefill certifications
    if (profile.certifications != null && profile.certifications!.isNotEmpty) {
      _certifications.clear();
      for (final cert in profile.certifications!) {
        _certifications.add({
          'name': TextEditingController(text: cert.name),
          'organization': TextEditingController(
            text: cert.issuingOrganization ?? '',
          ),
          'issueDate': TextEditingController(
            text: cert.issueDate?.toString().split(' ')[0] ?? '',
          ),
          'expiryDate': TextEditingController(
            text: cert.expiryDate?.toString().split(' ')[0] ?? '',
          ),
          'description': TextEditingController(text: cert.description ?? ''),
          'imageFile': null, // TODO: Handle image loading if needed
        });
      }
    }

    // Prefill achievements
    if (profile.achievements != null && profile.achievements!.isNotEmpty) {
      _achievements.clear();
      for (final achievement in profile.achievements!) {
        _achievements.add({
          'title': TextEditingController(text: achievement.title),
          'year': TextEditingController(text: achievement.year.toString()),
          'description': TextEditingController(
            text: achievement.description ?? '',
          ),
          'imageFile': null, // TODO: Handle image loading if needed
        });
      }
    }
  }

  @override
  void dispose() {
    _universityController.dispose();
    _majorController.dispose();
    _experienceController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Tạo hồ sơ năng lực', style: AppTextStyles.headlineSmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.largePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Education Section
              _buildSection(
                title: 'Thông tin học vấn',
                icon: Icons.school,
                children: [
                  _buildDropdownField(
                    label: 'Trình độ',
                    value: _selectedDegree,
                    items: degreeLabels.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDegree = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Vui lòng chọn trình độ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.defaultPadding),
                  AppTextField(
                    controller: _universityController,
                    label: 'Trường đại học',
                    hint: 'Tên trường đại học',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên trường';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.defaultPadding),
                  AppTextField(
                    controller: _majorController,
                    label: 'Chuyên ngành',
                    hint: 'Chuyên ngành học',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập chuyên ngành';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.defaultPadding),
                  _buildDropdownField(
                    label: 'Năm tốt nghiệp',
                    value: _graduationYear,
                    items: List.generate(30, (index) {
                      final year = DateTime.now().year - 29 + index;
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        _graduationYear = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Vui lòng chọn năm tốt nghiệp';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.largePadding),

              // Experience Section
              _buildSection(
                title: 'Kinh nghiệm giảng dạy',
                icon: Icons.work,
                children: [
                  _buildDropdownField(
                    label: 'Số năm kinh nghiệm',
                    value: _yearsOfTeaching,
                    items: List.generate(20, (index) {
                      return DropdownMenuItem(
                        value: index + 1,
                        child: Text('${index + 1} năm'),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        _yearsOfTeaching = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Vui lòng chọn số năm kinh nghiệm';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.defaultPadding),
                  _buildMultiSelectDropdown(
                    label: 'Môn học giảng dạy',
                    selectedItems: _selectedSubjects,
                    items: _subjects,
                    onChanged: (selectedItems) {
                      setState(() {
                        _selectedSubjects = selectedItems;
                      });
                    },
                    validator: (value) {
                      if (_selectedSubjects.isEmpty) {
                        return 'Vui lòng chọn ít nhất một môn học';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.defaultPadding),
                  AppTextField(
                    controller: _experienceController,
                    label: 'Mô tả kinh nghiệm',
                    hint: 'Mô tả chi tiết kinh nghiệm giảng dạy',
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mô tả kinh nghiệm';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.largePadding),

              // Certifications Section
              _buildSection(
                title: 'Chứng chỉ & Bằng cấp',
                icon: Icons.verified,
                children: [
                  _buildCertificationsList(),
                  const SizedBox(height: AppDimensions.defaultPadding),
                  _buildAddCertificationButton(),
                ],
              ),
              const SizedBox(height: AppDimensions.largePadding),

              // Achievements Section
              _buildSection(
                title: 'Thành tích & Giải thưởng',
                icon: Icons.emoji_events,
                children: [
                  _buildAchievementsList(),
                  const SizedBox(height: AppDimensions.defaultPadding),
                  _buildAddAchievementButton(),
                ],
              ),
              const SizedBox(height: AppDimensions.largePadding),

              // Additional Info Section
              _buildSection(
                title: 'Thông tin bổ sung',
                icon: Icons.info,
                children: [
                  AppTextField(
                    controller: _bioController,
                    label: 'Giới thiệu',
                    hint: 'Giới thiệu về bản thân',
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppDimensions.defaultPadding),
                  AppTextField(
                    controller: _websiteController,
                    label: 'Website cá nhân (tùy chọn)',
                    hint: 'https://example.com',
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.largePadding * 2),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed: _isLoading ? null : _submitProfile,
                  text: _isLoading
                      ? (widget.isEdit ? 'Đang cập nhật...' : 'Đang tạo...')
                      : (widget.isEdit
                            ? 'Cập nhật hồ sơ năng lực'
                            : 'Tạo hồ sơ năng lực'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 24),
                const SizedBox(width: AppDimensions.smallPadding),
                Text(title, style: AppTextStyles.titleMedium),
              ],
            ),
            const SizedBox(height: AppDimensions.defaultPadding),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    String? Function(T?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.inputLabel),
        const SizedBox(height: AppDimensions.smallPadding),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Chọn $label',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey500,
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.defaultRadius),
              borderSide: const BorderSide(color: AppColors.grey300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.defaultRadius),
              borderSide: const BorderSide(color: AppColors.grey300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.defaultRadius),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.defaultRadius),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.defaultRadius),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.defaultPadding,
              vertical: AppDimensions.defaultPadding,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelectDropdown({
    required String label,
    required List<ESubjectCode> selectedItems,
    required List<ESubjectCode> items,
    required ValueChanged<List<ESubjectCode>> onChanged,
    String? Function(List<ESubjectCode>)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.inputLabel),
        const SizedBox(height: AppDimensions.smallPadding),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey300),
            borderRadius: BorderRadius.circular(AppDimensions.defaultRadius),
          ),
          child: Column(
            children: [
              ...items.map(
                (item) => CheckboxListTile(
                  title: Text(
                    SubjectLabels.getLabel(item),
                    style: AppTextStyles.bodyMedium,
                  ),
                  value: selectedItems.contains(item),
                  onChanged: (bool? value) {
                    final newSelectedItems = List<ESubjectCode>.from(
                      selectedItems,
                    );
                    if (value == true) {
                      newSelectedItems.add(item);
                    } else {
                      newSelectedItems.remove(item);
                    }
                    onChanged(newSelectedItems);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCertificationsList() {
    if (_certifications.isEmpty) {
      return Text(
        'Chưa có chứng chỉ nào',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }

    return Column(
      children: _certifications.asMap().entries.map((entry) {
        final index = entry.key;
        final cert = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: AppDimensions.defaultPadding),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.defaultPadding),
            child: Column(
              children: [
                AppTextField(
                  controller: cert['name']!,
                  label: 'Tên chứng chỉ',
                  hint: 'Nhập tên chứng chỉ',
                ),
                const SizedBox(height: AppDimensions.defaultPadding),
                AppTextField(
                  controller: cert['organization']!,
                  label: 'Tổ chức cấp',
                  hint: 'Tổ chức cấp chứng chỉ',
                ),
                const SizedBox(height: AppDimensions.defaultPadding),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: cert['issueDate']!,
                        label: 'Ngày cấp',
                        hint: 'DD/MM/YYYY',
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.defaultPadding),
                    Expanded(
                      child: AppTextField(
                        controller: cert['expiryDate']!,
                        label: 'Ngày hết hạn (tùy chọn)',
                        hint: 'DD/MM/YYYY',
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.defaultPadding),
                AppTextField(
                  controller: cert['description']!,
                  label: 'Mô tả (tùy chọn)',
                  hint: 'Mô tả chi tiết về chứng chỉ',
                  maxLines: 2,
                ),
                const SizedBox(height: AppDimensions.defaultPadding),
                // Image upload section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hình ảnh chứng chỉ (tùy chọn)',
                      style: AppTextStyles.inputLabel,
                    ),
                    const SizedBox(height: AppDimensions.smallPadding),
                    GestureDetector(
                      onTap: () => _pickCertificationImage(index),
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey300),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.defaultRadius,
                          ),
                        ),
                        child: cert['imageFile'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.defaultRadius,
                                ),
                                child: Image.file(
                                  cert['imageFile']!,
                                  width: double.infinity,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.upload_file,
                                      color: AppColors.textSecondary,
                                      size: 32,
                                    ),
                                    const SizedBox(
                                      height: AppDimensions.smallPadding,
                                    ),
                                    Text(
                                      'Chưa có hình ảnh',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: AppDimensions.smallPadding,
                                    ),
                                    Text(
                                      'Nhấn để chọn ảnh',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    if (cert['imageFile'] != null) ...[
                      const SizedBox(height: AppDimensions.smallPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () => _removeCertificationImage(index),
                            icon: const Icon(Icons.delete, size: 18),
                            label: Text(
                              'Xóa hình ảnh',
                              style: AppTextStyles.buttonMedium.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppDimensions.defaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _certifications.removeAt(index);
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: AppColors.error,
                        size: 18,
                      ),
                      label: Text(
                        'Xóa chứng chỉ',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddCertificationButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          setState(() {
            _certifications.add({
              'name': TextEditingController(),
              'organization': TextEditingController(),
              'issueDate': TextEditingController(),
              'expiryDate': TextEditingController(),
              'description': TextEditingController(),
              'imageFile': null,
            });
          });
        },
        icon: const Icon(Icons.add),
        label: Text(
          'Thêm chứng chỉ',
          style: AppTextStyles.buttonMedium.copyWith(color: AppColors.primary),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildAchievementsList() {
    if (_achievements.isEmpty) {
      return Text(
        'Chưa có thành tích nào',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }

    return Column(
      children: _achievements.asMap().entries.map((entry) {
        final index = entry.key;
        final achievement = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: AppDimensions.defaultPadding),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.defaultPadding),
            child: Column(
              children: [
                AppTextField(
                  controller: achievement['title']!,
                  label: 'Tên thành tích',
                  hint: 'Nhập tên thành tích',
                ),
                const SizedBox(height: AppDimensions.defaultPadding),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: achievement['year']!,
                        label: 'Năm',
                        hint: 'Năm đạt được',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.defaultPadding),
                    Expanded(
                      child: AppTextField(
                        controller: achievement['description']!,
                        label: 'Mô tả',
                        hint: 'Mô tả thành tích',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.defaultPadding),
                // Image upload section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hình ảnh thành tích (tùy chọn)',
                      style: AppTextStyles.inputLabel,
                    ),
                    const SizedBox(height: AppDimensions.smallPadding),
                    GestureDetector(
                      onTap: () => _pickAchievementImage(index),
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey300),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.defaultRadius,
                          ),
                        ),
                        child: achievement['imageFile'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.defaultRadius,
                                ),
                                child: Image.file(
                                  achievement['imageFile']!,
                                  width: double.infinity,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.upload_file,
                                      color: AppColors.textSecondary,
                                      size: 32,
                                    ),
                                    const SizedBox(
                                      height: AppDimensions.smallPadding,
                                    ),
                                    Text(
                                      'Chưa có hình ảnh',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: AppDimensions.smallPadding,
                                    ),
                                    Text(
                                      'Nhấn để chọn ảnh',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    if (achievement['imageFile'] != null) ...[
                      const SizedBox(height: AppDimensions.smallPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () => _removeAchievementImage(index),
                            icon: const Icon(Icons.delete, size: 18),
                            label: Text(
                              'Xóa hình ảnh',
                              style: AppTextStyles.buttonMedium.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppDimensions.defaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _achievements.removeAt(index);
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: AppColors.error,
                        size: 18,
                      ),
                      label: Text(
                        'Xóa thành tích',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddAchievementButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          setState(() {
            _achievements.add({
              'title': TextEditingController(),
              'year': TextEditingController(),
              'description': TextEditingController(),
              'imageFile': null,
            });
          });
        },
        icon: const Icon(Icons.add),
        label: Text(
          'Thêm thành tích',
          style: AppTextStyles.buttonMedium.copyWith(color: AppColors.primary),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final createDto = CreateTeacherProfileDto(
        degree: _selectedDegree?.name,
        graduationYear: _graduationYear!,
        university: _universityController.text,
        major: _majorController.text,
        yearsOfTeaching: _yearsOfTeaching!,
        experienceDescription: _experienceController.text,
        bio: _bioController.text.isNotEmpty ? _bioController.text : null,
        personalWebsite: _websiteController.text.isNotEmpty
            ? _websiteController.text
            : null,
        subjects: _selectedSubjects
            .map((subject) => CreateTeacherSubjectDto(subject: subject.value))
            .toList(),
        certifications: _certifications
            .map(
              (cert) => CreateTeacherCertificationDto(
                name: cert['name']!.text,
                issuingOrganization: cert['organization']!.text.isNotEmpty
                    ? cert['organization']!.text
                    : null,
                issueDate: cert['issueDate']!.text.isNotEmpty
                    ? cert['issueDate']!.text
                    : null,
                expiryDate: cert['expiryDate']!.text.isNotEmpty
                    ? cert['expiryDate']!.text
                    : null,
                description: cert['description']!.text.isNotEmpty
                    ? cert['description']!.text
                    : null,
                imageUrl: cert['imageFile'] != null
                    ? cert['imageFile']!.path
                    : null,
              ),
            )
            .toList(),
        achievements: _achievements
            .map(
              (achievement) => CreateTeacherAchievementDto(
                title: achievement['title']!.text,
                year:
                    int.tryParse(achievement['year']!.text) ??
                    DateTime.now().year,
                description: achievement['description']!.text.isNotEmpty
                    ? achievement['description']!.text
                    : null,
                imageUrl: achievement['imageFile'] != null
                    ? achievement['imageFile']!.path
                    : null,
              ),
            )
            .toList(),
      );

      print('🔍 CreateTeacherProfileScreen: Submitting profile...');
      print('🔍 CreateTeacherProfileScreen: DTO: ${createDto.toJson()}');

      // Call the API
      final teacherProfileApi = ref.read(teacherProfileApiProvider);
      if (widget.isEdit) {
        final updateDto = UpdateTeacherProfileDto(
          degree: _selectedDegree?.name,
          graduationYear: _graduationYear!,
          university: _universityController.text,
          major: _majorController.text,
          yearsOfTeaching: _yearsOfTeaching!,
          experienceDescription: _experienceController.text,
          bio: _bioController.text.isNotEmpty ? _bioController.text : null,
          personalWebsite: _websiteController.text.isNotEmpty
              ? _websiteController.text
              : null,
          subjects: _selectedSubjects
              .map((subject) => UpdateTeacherSubjectDto(subject: subject.value))
              .toList(),
          certifications: _certifications
              .map(
                (cert) => UpdateTeacherCertificationDto(
                  name: cert['name']!.text,
                  issuingOrganization: cert['organization']!.text.isNotEmpty
                      ? cert['organization']!.text
                      : null,
                  issueDate: cert['issueDate']!.text.isNotEmpty
                      ? cert['issueDate']!.text
                      : null,
                  expiryDate: cert['expiryDate']!.text.isNotEmpty
                      ? cert['expiryDate']!.text
                      : null,
                  description: cert['description']!.text.isNotEmpty
                      ? cert['description']!.text
                      : null,
                  imageUrl: cert['imageFile'] != null
                      ? cert['imageFile']!.path
                      : null,
                ),
              )
              .toList(),
          achievements: _achievements
              .map(
                (achievement) => UpdateTeacherAchievementDto(
                  title: achievement['title']!.text,
                  year:
                      int.tryParse(achievement['year']!.text) ??
                      DateTime.now().year,
                  description: achievement['description']!.text.isNotEmpty
                      ? achievement['description']!.text
                      : null,
                  imageUrl: achievement['imageFile'] != null
                      ? achievement['imageFile']!.path
                      : null,
                ),
              )
              .toList(),
        );
        await teacherProfileApi.updateProfile(updateDto);
        print('✅ CreateTeacherProfileScreen: Profile updated successfully');
      } else {
        await teacherProfileApi.createProfile(createDto);
        print('✅ CreateTeacherProfileScreen: Profile created successfully');
      }

      ToastUtils.showSuccess(
        context: context,
        message: widget.isEdit
            ? 'Cập nhật hồ sơ năng lực thành công'
            : 'Tạo hồ sơ năng lực thành công',
      );

      // Refresh the profile provider
      ref.invalidate(teacherProfileProvider);

      // Navigate back
      Navigator.of(context).pop();
    } catch (e) {
      print('❌ CreateTeacherProfileScreen: Error submitting profile: $e');
      ToastUtils.showFail(
        context: context,
        message:
            'Không thể ${widget.isEdit ? 'cập nhật' : 'tạo'} hồ sơ năng lực: $e',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickCertificationImage(int index) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _certifications[index]['imageFile'] = pickedFile;
      });
    }
  }

  void _removeCertificationImage(int index) {
    setState(() {
      _certifications[index]['imageFile'] = null;
    });
  }

  Future<void> _pickAchievementImage(int index) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _achievements[index]['imageFile'] = pickedFile;
      });
    }
  }

  void _removeAchievementImage(int index) {
    setState(() {
      _achievements[index]['imageFile'] = null;
    });
  }
}
