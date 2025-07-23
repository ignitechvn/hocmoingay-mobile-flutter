import '../../domain/entities/classroom.dart';
import 'app_constants.dart';

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
  static const Map<String, String> labels = {
    'MATH': 'Toán',
    'PHYSICS': 'Vật lý',
    'CHEMISTRY': 'Hóa học',
    'ENGLISH': 'Tiếng Anh',
    'INFORMATION_TECHOLOGY': 'Tin học',
  };

  static String getLabel(String code) {
    return labels[code] ?? code;
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
 