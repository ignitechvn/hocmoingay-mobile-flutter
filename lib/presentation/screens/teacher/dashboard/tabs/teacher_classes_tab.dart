import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocmoingay/data/dto/classroom_dto.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/error/api_error_handler.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/empty_state_widget.dart';
import '../../../../../data/dto/classroom_dto.dart';
import '../../../../../domain/entities/classroom.dart';
import '../../../../../providers/teacher_classroom/teacher_classroom_providers.dart';
import '../widgets/teacher_status_filter_bar.dart';
import '../../schedule/teacher_schedule_screen.dart';
import '../widgets/teacher_classroom_card.dart';
import '../../classroom/create_classroom_screen.dart';
import '../../classroom/teacher_classroom_details_screen.dart';

class TeacherClassesTab extends ConsumerStatefulWidget {
  const TeacherClassesTab({super.key});

  @override
  ConsumerState<TeacherClassesTab> createState() => _TeacherClassesTabState();
}

class _TeacherClassesTabState extends ConsumerState<TeacherClassesTab> {
  int _selectedStatusIndex = 0;

  @override
  Widget build(BuildContext context) {
    print('🔍 TeacherClassesTab: Building widget');
    final classroomsAsync = ref.watch(teacherClassroomsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Danh sách lớp học',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          // Create class button
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateClassroomScreen(),
                  ),
                );
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
                  Icons.add, // Đổi từ add_circle_outline sang add
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
          // Schedule button
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TeacherScheduleScreen(),
                  ),
                );
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
                  Icons.calendar_today,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Filter Bar
          TeacherStatusFilterBar(
            selectedIndex: _selectedStatusIndex,
            onStatusChanged: (index) {
              setState(() {
                _selectedStatusIndex = index;
              });
            },
          ),

          // Classrooms List
          Expanded(
            child: classroomsAsync.when(
              data: _buildClassroomsList,
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) {
                final errorMessage =
                    ApiErrorHandler.parseErrorResponse(error)?.message ??
                    'Đã xảy ra lỗi không xác định';
                return EmptyStateWidgets.error(
                  message: errorMessage,
                  onRetry: null, // Không hiển thị nút "Thử lại"
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassroomsList(TeacherClassroomResponseListDto classrooms) {
    var selectedClassrooms = <ClassroomTeacherResponseDto>[];

    switch (_selectedStatusIndex) {
      case 0:
        selectedClassrooms = classrooms.enrollingClassrooms;
        break;
      case 1:
        selectedClassrooms = classrooms.ongoingClassrooms;
        break;
      case 2:
        selectedClassrooms = classrooms.finishedClassrooms;
        break;
    }

    if (selectedClassrooms.isEmpty) {
      return EmptyStateWidgets.noClassrooms(
        onRefresh: null, // Không hiển thị nút "Làm mới"
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: selectedClassrooms.length,
      itemBuilder: (BuildContext context, int index) {
        final classroom = selectedClassrooms[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TeacherClassroomCard(
            classroom: _convertToClassroomTeacher(classroom),
            onTap: () => _handleClassroomAction(classroom),
          ),
        );
      },
    );
  }

  // Convert ClassroomTeacherResponseDto to ClassroomTeacher
  ClassroomTeacher _convertToClassroomTeacher(
    ClassroomTeacherResponseDto classroom,
  ) => ClassroomTeacher(
    id: classroom.id,
    name: classroom.name,
    code: classroom.code,
    joinCode: classroom.joinCode,
    grade: classroom.grade,
    status: classroom.status,
    lessonSessionCount: classroom.lessonSessionCount,
    lessonLearnedCount: classroom.lessonLearnedCount,
    startDate: _parseDate(classroom.startDate),
    endDate: _parseDate(classroom.endDate),
    totalStudents: classroom.totalStudents,
    schedule:
        classroom.schedule
            .map(
              (ScheduleResponseDto s) => Schedule(
                dayOfWeek: s.dayOfWeek,
                startTime: s.startTime,
                endTime: s.endTime,
              ),
            )
            .toList(),
    lessonSessions:
        classroom.lessonSessions
            .map(
              (LessonSessionResponseDto ls) => LessonSession(
                id: ls.id,
                date: _parseDate(ls.date),
                startTime: ls.startTime,
                endTime: ls.endTime,
                status: ls.status,
                note: ls.note,
                originalSessionId: ls.originalSessionId,
              ),
            )
            .toList(),
  );

  void _handleClassroomAction(ClassroomTeacherResponseDto classroom) {
    // Navigate to classroom details screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) =>
                TeacherClassroomDetailsScreen(classroomId: classroom.id),
      ),
    );
  }

  // Parse date from backend format
  DateTime _parseDate(String dateString) {
    try {
      // Try ISO format first
      return DateTime.parse(dateString);
    } catch (e) {
      // Handle backend format: "Tue Jul 22 2025 17:00:00 GMT+0000 (Coordinated Universal Time)"
      try {
        // Extract the date part and convert to ISO format
        final parts = dateString.split(' ');
        if (parts.length >= 6) {
          final day = parts[2];
          final month = _getMonthNumber(parts[1]);
          final year = parts[3];
          final time = parts[4];

          // Create ISO format: "2025-07-22T17:00:00"
          final isoDate = '$year-$month-$day $time';
          return DateTime.parse(isoDate);
        }
      } catch (e2) {
        print('❌ Failed to parse date: $dateString - $e2');
      }

      // Fallback to current date
      return DateTime.now();
    }
  }

  String _getMonthNumber(String monthName) {
    switch (monthName) {
      case 'Jan':
        return '01';
      case 'Feb':
        return '02';
      case 'Mar':
        return '03';
      case 'Apr':
        return '04';
      case 'May':
        return '05';
      case 'Jun':
        return '06';
      case 'Jul':
        return '07';
      case 'Aug':
        return '08';
      case 'Sep':
        return '09';
      case 'Oct':
        return '10';
      case 'Nov':
        return '11';
      case 'Dec':
        return '12';
      default:
        return '01';
    }
  }
}
