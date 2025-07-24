import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/classroom.dart';
import '../../../../providers/student_classroom/student_classroom_providers.dart';
import '../../common/schedule_screen.dart';

class StudentScheduleScreen extends ConsumerWidget {
  const StudentScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classroomsAsync = ref.watch(studentClassroomsProvider);

    return classroomsAsync.when(
      data: (classrooms) {
        // Get all active classrooms (ongoing and enrolling)
        final activeClassrooms = [
          ...classrooms.ongoingClassrooms,
          ...classrooms.enrollingClassrooms,
        ];

        return CommonScheduleScreen(
          classrooms: activeClassrooms,
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
}
