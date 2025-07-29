import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/grade_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/dto/auth_dto.dart';
import '../../../domain/entities/user.dart';
import '../../../providers/auth/auth_state_provider.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedGender;
  String? _selectedGrade;
  String? _selectedImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    final user = ref.read(authStateProvider).user;
    if (user != null) {
      _fullNameController.text = user.fullName;
      _addressController.text = user.address;
      _emailController.text = user.email ?? '';
      _selectedGender = user.gender.value;
      _selectedGrade = user.grade?.value;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Cập nhật thông tin',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.largePadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Section
              _buildAvatarSection(user),
              const SizedBox(height: AppDimensions.largePadding),

              // Form Fields
              _buildFormFields(user),
              const SizedBox(height: AppDimensions.largePadding),

              // Update Button
              _buildUpdateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(User? user) {
    return Center(
      child: Column(
        children: [
          // Avatar
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: _selectedImagePath != null
                  ? ClipOval(
                      child: Image.file(
                        File(_selectedImagePath!),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    )
                  : user?.avatar != null && user!.avatar!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        user.avatar!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildAvatarWithInitial(user.fullName),
                      ),
                    )
                  : _buildAvatarWithInitial(user?.fullName),
            ),
          ),
          const SizedBox(height: AppDimensions.defaultPadding),
          Text(
            'Chạm để thay đổi ảnh',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarWithInitial(String? fullName) {
    String initial = '?';
    if (fullName != null && fullName.isNotEmpty) {
      final nameParts = fullName.trim().split(' ');
      if (nameParts.isNotEmpty) {
        initial = nameParts.first[0].toUpperCase();
      }
    }

    return Center(
      child: Text(
        initial,
        style: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFormFields(User? user) {
    return Column(
      children: [
        // Full Name
        AppTextField(
          controller: _fullNameController,
          label: 'Họ và tên',
          hint: 'Nhập họ và tên',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập họ và tên';
            }
            return null;
          },
        ),
        const SizedBox(height: AppDimensions.defaultPadding),

        // Address
        AppTextField(
          controller: _addressController,
          label: 'Địa chỉ',
          hint: 'Nhập địa chỉ',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập địa chỉ';
            }
            return null;
          },
        ),
        const SizedBox(height: AppDimensions.defaultPadding),

        // Email
        AppTextField(
          controller: _emailController,
          label: 'Email (tùy chọn)',
          hint: 'Nhập email',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!RegExp(AppConstants.emailPattern).hasMatch(value)) {
                return 'Email không hợp lệ';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: AppDimensions.defaultPadding),

        // Gender
        _buildDropdownField(
          label: 'Giới tính',
          value: _selectedGender,
          items: [
            {'value': 'male', 'label': 'Nam'},
            {'value': 'female', 'label': 'Nữ'},
            {'value': 'other', 'label': 'Khác'},
          ],
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
        ),
        const SizedBox(height: AppDimensions.defaultPadding),

        // Grade (only for students)
        if (user?.role == Role.student) ...[
          _buildDropdownField(
            label: 'Khối lớp',
            value: _selectedGrade,
            items: EGradeLevel.values
                .map((grade) => {'value': grade.value, 'label': grade.label})
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedGrade = value;
              });
            },
          ),
          const SizedBox(height: AppDimensions.defaultPadding),
        ],
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<Map<String, String>> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppDimensions.smallPadding),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.defaultPadding,
            vertical: AppDimensions.smallPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text(
                'Chọn $label',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item['value'],
                  child: Text(
                    item['label']!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        onPressed: _isLoading ? null : _updateProfile,
        text: _isLoading ? 'Đang cập nhật...' : 'Cập nhật thông tin',
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = ref.read(authStateProvider).user;
      if (user == null) {
        ToastUtils.showFail(
          context: context,
          message: 'Không thể lấy thông tin người dùng',
        );
        return;
      }

      // TODO: Implement API call based on user role
      // For now, just show success message
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      ToastUtils.showSuccess(
        context: context,
        message: 'Cập nhật thông tin thành công',
      );

      Navigator.of(context).pop();
    } catch (e) {
      ToastUtils.showFail(context: context, message: 'Có lỗi xảy ra: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
