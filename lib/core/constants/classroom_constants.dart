import 'package:flutter/material.dart';
import '../../domain/entities/classroom.dart';
import 'app_constants.dart';
import 'subject_constants.dart';

// Student Classroom Status Background Colors
class StudentClassroomStatusBackgroundColor {
  static const Map<ClassroomStudentStatus, String> colors = {
    ClassroomStudentStatus.actived: "#E2F7F0",
    ClassroomStudentStatus.waitingTeacherConfirm: '#FEF5E7',
    ClassroomStudentStatus.waitingStudentConfirm: '#FEF5E7',
    ClassroomStudentStatus.rejectedByStudent: "#FDE9E9",
    ClassroomStudentStatus.rejectedByTeacher: "#FDE9E9",
  };
}

// Classroom Status Background Colors
class ClassroomStatusBackgroundColor {
  static const Map<ClassroomStatus, String> colors = {
    ClassroomStatus.enrolling: "#ECF4FE",
    ClassroomStatus.ongoing: "#E2F7F0",
    ClassroomStatus.finished: "#FDE9E9",
    ClassroomStatus.canceled: "#FDE9E9",
  };
}

// Subject Labels
class SubjectLabels {
  static const Map<ESubjectCode, String> labels = {
    ESubjectCode.MATH: 'Toán',
    ESubjectCode.PHYSICS: 'Vật lý',
    ESubjectCode.CHEMISTRY: 'Hóa học',
    ESubjectCode.ENGLISH: 'Tiếng Anh',
    ESubjectCode.INFORMATION_TECHOLOGY: 'Tin học',
  };

  static String getLabel(ESubjectCode code) {
    return labels[code] ?? code.value;
  }
}

// Helper function to convert schedule list to text
List<String> convertScheduleListToText(List<Schedule> schedules) {
  if (schedules.isEmpty) return [];

  final dayNames = {
    1: 'Thứ 2',
    2: 'Thứ 3',
    3: 'Thứ 4',
    4: 'Thứ 5',
    5: 'Thứ 6',
    6: 'Thứ 7',
    7: 'Chủ nhật',
  };

  return schedules.map((schedule) {
    final dayName = dayNames[schedule.dayOfWeek] ?? 'Thứ ${schedule.dayOfWeek}';
    return '$dayName ${schedule.startTime}-${schedule.endTime}';
  }).toList();
}

// Helper function to format date
String formatDatetimeToDDMMYYYY(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

// Classroom Constants for UI
class ClassroomConstants {
  // Status colors
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'enrolling':
        return const Color(0xFF2196F3); // Blue
      case 'ongoing':
        return const Color(0xFF4CAF50); // Green
      case 'finished':
        return const Color(0xFFF44336); // Red
      case 'canceled':
        return const Color(0xFF9E9E9E); // Grey
      default:
        return const Color(0xFF2196F3);
    }
  }

  // Status text
  static String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'enrolling':
        return 'Đang tuyển sinh';
      case 'ongoing':
        return 'Đang diễn ra';
      case 'finished':
        return 'Đã kết thúc';
      case 'canceled':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  // Day of week text
  static String getDayOfWeekText(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'Thứ 2';
      case 2:
        return 'Thứ 3';
      case 3:
        return 'Thứ 4';
      case 4:
        return 'Thứ 5';
      case 5:
        return 'Thứ 6';
      case 6:
        return 'Thứ 7';
      case 7:
        return 'Chủ nhật';
      default:
        return 'Thứ $dayOfWeek';
    }
  }

  // Session status colors
  static Color getSessionStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return const Color(0xFF2196F3); // Blue
      case 'ongoing':
        return const Color(0xFF4CAF50); // Green
      case 'completed':
        return const Color(0xFF8BC34A); // Light Green
      case 'cancelled':
        return const Color(0xFFF44336); // Red
      case 'postponed':
        return const Color(0xFFFF9800); // Orange
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  // Session status icons
  static IconData getSessionStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Icons.schedule;
      case 'ongoing':
        return Icons.play_circle_outline;
      case 'completed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'postponed':
        return Icons.schedule_send;
      default:
        return Icons.help_outline;
    }
  }

  // Session status text
  static String getSessionStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return 'Đã lên lịch';
      case 'ongoing':
        return 'Đang diễn ra';
      case 'completed':
        return 'Đã hoàn thành';
      case 'cancelled':
        return 'Đã hủy';
      case 'postponed':
        return 'Tạm hoãn';
      default:
        return 'Không xác định';
    }
  }
}
