import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/classroom_constants.dart';
import '../../../../core/constants/subject_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/teacher_profile_dto.dart';
import '../../../../providers/teacher_profile/teacher_profile_providers.dart';
import 'create_teacher_profile_screen.dart';

class TeacherProfileScreen extends ConsumerStatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  ConsumerState<TeacherProfileScreen> createState() =>
      _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends ConsumerState<TeacherProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Test API connection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teacherProfileTestProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(teacherProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Hồ sơ năng lực',
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
        actions: [
          // Edit button - only show when profile exists
          if (profileAsync.when(
            data: (profile) => profile != null,
            loading: () => false,
            error: (_, __) => false,
          ))
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () {
                  final profile = profileAsync.asData?.value;
                  if (profile != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CreateTeacherProfileScreen(
                          profile: profile,
                          isEdit: true,
                        ),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          print(
            '✅ TeacherProfileScreen: Data received: ${profile?.id ?? 'null'}',
          );
          return _buildContent(context, profile);
        },
        loading: () {
          print('⏳ TeacherProfileScreen: Loading...');
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stack) {
          print('❌ TeacherProfileScreen: Error: $error');
          print('❌ TeacherProfileScreen: Stack trace: $stack');
          return Center(
            child: EmptyStateWidgets.error(
              message: 'Không thể tải hồ sơ năng lực',
              onRetry: () {
                print('🔄 TeacherProfileScreen: Retrying...');
                ref.invalidate(teacherProfileProvider);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TeacherProfileResponseDto? profile,
  ) {
    if (profile == null) {
      return _buildEmptyProfile();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.largePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Education Section
          _buildSection(
            title: 'Thông tin học vấn',
            icon: Icons.school,
            children: [
              if (profile.degree != null)
                _buildInfoRow('Trình độ', getDegreeLabel(profile.degree!)),
              if (profile.graduationYear != null)
                _buildInfoRow(
                  'Năm tốt nghiệp',
                  profile.graduationYear!.toString(),
                ),
              if (profile.university != null)
                _buildInfoRow('Trường đại học', profile.university!),
              if (profile.major != null)
                _buildInfoRow('Chuyên ngành', profile.major!),
            ],
          ),
          const SizedBox(height: AppDimensions.largePadding),

          // Experience Section
          _buildSection(
            title: 'Kinh nghiệm giảng dạy',
            icon: Icons.work,
            children: [
              if (profile.yearsOfTeaching != null)
                _buildInfoRow(
                  'Số năm kinh nghiệm',
                  '${profile.yearsOfTeaching} năm',
                ),
              if (profile.subjects != null && profile.subjects!.isNotEmpty)
                _buildInfoRow(
                  'Môn học giảng dạy',
                  profile.subjects!
                      .map((subject) {
                        try {
                          final subjectCode = ESubjectCode.fromString(
                            subject.subject,
                          );
                          return SubjectLabels.getLabel(subjectCode);
                        } catch (e) {
                          // Fallback to original subject name if conversion fails
                          return subject.subject;
                        }
                      })
                      .join(', '),
                ),
              if (profile.experienceDescription != null)
                _buildInfoRow(
                  'Mô tả kinh nghiệm',
                  profile.experienceDescription!,
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.largePadding),

          // Certifications Section
          if (profile.certifications != null &&
              profile.certifications!.isNotEmpty) ...[
            _buildSection(
              title: 'Chứng chỉ',
              icon: Icons.verified,
              children: profile.certifications!
                  .map((cert) => _buildCertificationCard(cert))
                  .toList(),
            ),
            const SizedBox(height: AppDimensions.largePadding),
          ],

          // Achievements Section
          if (profile.achievements != null &&
              profile.achievements!.isNotEmpty) ...[
            _buildSection(
              title: 'Thành tích',
              icon: Icons.emoji_events,
              children: profile.achievements!
                  .map((achievement) => _buildAchievementCard(achievement))
                  .toList(),
            ),
            const SizedBox(height: AppDimensions.largePadding),
          ],

          // Additional Info Section
          if (profile.personalWebsite != null || profile.bio != null) ...[
            _buildSection(
              title: 'Thông tin bổ sung',
              icon: Icons.info,
              children: [
                if (profile.personalWebsite != null)
                  _buildInfoRow('Website cá nhân', profile.personalWebsite!),
                if (profile.bio != null)
                  _buildInfoRow('Giới thiệu', profile.bio!),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyProfile() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.largePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add, size: 80, color: AppColors.textSecondary),
            const SizedBox(height: AppDimensions.largePadding),
            Text(
              'Chưa có hồ sơ năng lực',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.defaultPadding),
            Text(
              'Tạo hồ sơ năng lực để hiển thị thông tin chuyên môn của bạn',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.largePadding),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateTeacherProfileScreen(),
                    ),
                  );
                },
                text: 'Tạo hồ sơ năng lực',
              ),
            ),
          ],
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
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.defaultPadding),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppDimensions.smallPadding),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationCard(TeacherCertificationResponseDto cert) {
    return SizedBox(
      width: double.infinity,
      child: IntrinsicHeight(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: AppColors.primary.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cert.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (cert.issuingOrganization != null) ...[
                  const SizedBox(height: AppDimensions.smallPadding),
                  Text(
                    'Tổ chức cấp: ${cert.issuingOrganization}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (cert.description != null) ...[
                  const SizedBox(height: AppDimensions.smallPadding),
                  Text(
                    cert.description!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard(TeacherAchievementResponseDto achievement) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: AppColors.success.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    achievement.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.smallPadding,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    achievement.year.toString(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (achievement.description != null) ...[
              const SizedBox(height: AppDimensions.smallPadding),
              Text(
                achievement.description!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
