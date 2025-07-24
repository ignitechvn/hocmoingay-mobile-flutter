import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/classroom.dart';
import '../../../../providers/teacher_classroom/teacher_classroom_providers.dart';
import '../../common/schedule_screen.dart';

class TeacherScheduleScreen extends ConsumerWidget {
  const TeacherScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classroomsAsync = ref.watch(teacherClassroomsProvider);

    return classroomsAsync.when(
      data: (classrooms) {
        // Get all active classrooms (ongoing and enrolling)
        final activeClassrooms = [
          ...classrooms.ongoingClassrooms,
          ...classrooms.enrollingClassrooms,
        ];

        // Convert ClassroomTeacherResponseDto to ClassroomTeacher
        final convertedClassrooms =
            activeClassrooms.map((classroom) {
              return ClassroomTeacher(
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
                          (s) => Schedule(
                            dayOfWeek: s.dayOfWeek,
                            startTime: s.startTime,
                            endTime: s.endTime,
                          ),
                        )
                        .toList(),
                lessonSessions:
                    classroom.lessonSessions
                        .map(
                          (ls) => LessonSession(
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
            }).toList();

        return CommonScheduleScreen(
          classrooms: convertedClassrooms,
          title: 'Thời khóa biểu',
        );
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (error, stack) => Scaffold(
            body: Center(
              child: Text(
                'Đã xảy ra lỗi khi tải thời khóa biểu',
                style: TextStyle(color: Colors.red),
              ),
            ),
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
