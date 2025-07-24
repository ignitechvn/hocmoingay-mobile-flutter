enum ENotificationType {
  JOIN_CLASSROOM_REQUEST_APPROVED,
  JOIN_CLASSROOM_REQUEST_REJECTED,
  CHAPTER_OPEN,
  CHAPTER_CLOSED,
  CHAPTER_ALMOST_OVER,
  CHAPTER_INSERT_QUESTION,
  PRACTICE_SET_OPEN,
  PRACTICE_SET_CLOSED,
  PRACTICE_SET_ALMOST_OVER,
  PRACTICE_SET_INSERT_QUESTION,
  EXAM_ABOUT_TO_GEGIN,
  EXAM_OPEN,
  EXAM_CLOSED,
  EXAM_ALMOST_OVER,
  EXAM_HAS_BEEN_GRADED,
  SYSTEM,
}

class NotificationConstants {
  static const Map<String, String> NOTIFICATION_CONTENT_STUDENT = {
    'JOIN_CLASSROOM_REQUEST_APPROVED':
        'Bạn đã được phê duyệt tham gia lớp {{param}} Bây giờ bạn có thể làm bài tập và theo dõi kết quả làm bài của mình.',
    'JOIN_CLASSROOM_REQUEST_REJECTED':
        'Bạn bị từ chối tham gia lớp {{param}} Liên hệ ngay với giáo viên để biết lý do.',
    'CHAPTER_OPEN':
        'Bạn đã có thể bắt đầu làm bài tập trong chủ đề {{param}} của lớp {{param}} Làm ngay thôi nào.',
    'CHAPTER_CLOSED':
        'Chủ đề {{param}} của lớp {{param}} đã kết thúc. Hãy vào xem kết quả làm bài tập của mình nhé.',
    'CHAPTER_ALMOST_OVER':
        'Sắp hết hạn làm bài tập trong chủ đề {{param}} của lớp {{param}} Hãy kiểm tra lại các câu đã làm và hoàn thành các câu chưa làm bạn nhé.',
    'CHAPTER_INSERT_QUESTION':
        'Chủ đề {{param}} của lớp {{param}} vừa được bổ sung câu hỏi mới, bạn hãy vào làm bài tập nhé!',
    'PRACTICE_SET_OPEN':
        'Bạn đã có thể bắt đầu làm bài tập tổng hợp {{param}} của lớp {{param}} Làm ngay thôi nào!',
    'PRACTICE_SET_CLOSED':
        'Bài tập tổng hợp {{param}} của lớp {{param}} đã kết thúc. Hãy vào xem kết quả làm bài tập của mình nhé!',
    'PRACTICE_SET_ALMOST_OVER':
        'Sắp hết hạn làm bài tập tổng hợp {{param}} của lớp {{param}}. Hãy kiểm tra lại các câu đã làm và hoàn thành các câu chưa làm bạn nhé!',
    'PRACTICE_SET_INSERT_QUESTION':
        'Bài tập tổng hợp {{param}} của lớp {{param}} vừa được bổ sung câu hỏi mới, bạn hãy vào làm bài tập nhé!',
    'EXAM_ABOUT_TO_GEGIN':
        'Bài thi {{param}} của lớp {{param}} sẽ bắt đầu vào lúc {{param}}. Bạn hãy tham gia đúng giờ nhé!',
    'EXAM_OPEN':
        'Bài thi {{param}} của lớp {{param}} đã đã bắt đầu. Hãy vào làm bài của mình nhé!',
    'EXAM_CLOSED':
        'Bài thi {{param}} của lớp {{param}} đã kết thúc. Hãy xem kết quả làm bài của mình nhé!',
    'EXAM_ALMOST_OVER':
        'Bài thi {{param}} của lớp {{param}} sẽ sớm kết thúc sau 15 phút nữa!',
    'EXAM_HAS_BEEN_GRADED':
        'Bài thi {{param}} của lớp {{param}} đã được chấm điểm. Số điểm bạn đạt được là {{param}}',
    'SYSTEM': 'Thông báo hệ thống',
  };

  static String generateNotificationContent(
    String type,
    Map<String, dynamic>? params,
  ) {
    final content = NOTIFICATION_CONTENT_STUDENT[type];
    if (content == null || params == null) return content ?? 'Thông báo';

    List<String> paramArr = [];

    if (type.startsWith('CHAPTER')) {
      paramArr = [
        params['chapterTitle'] ?? 'Không xác định',
        params['classroomName'] ?? 'Không xác định',
      ];
    } else if (type.startsWith('PRACTICE')) {
      paramArr = [
        params['practiceSetTitle'] ?? 'Không xác định',
        params['classroomName'] ?? 'Không xác định',
      ];
    } else if (type == 'EXAM_HAS_BEEN_GRADED') {
      paramArr = [
        params['examTitle'] ?? 'Không xác định',
        params['classroomName'] ?? 'Không xác định',
        params['score']?.toString() ?? 'N/A',
      ];
    } else if (type == 'EXAM_ABOUT_TO_GEGIN') {
      paramArr = [
        params['examTitle'] ?? 'Không xác định',
        params['classroomName'] ?? 'Không xác định',
        _formatDateTime(params['startTime']),
      ];
    } else if (type.startsWith('EXAM')) {
      paramArr = [
        params['examTitle'] ?? 'Không xác định',
        params['classroomName'] ?? 'Không xác định',
      ];
    } else if (type.startsWith('JOIN')) {
      paramArr = [params['classroomName'] ?? 'Không xác định'];
    }

    String result = content;
    for (final param in paramArr) {
      result = result.replaceFirst('{{param}}', param);
    }

    return result;
  }

  static String _formatDateTime(dynamic dateTime) {
    if (dateTime == null) return 'Không xác định';

    try {
      if (dateTime is String) {
        final date = DateTime.parse(dateTime);
        return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      }
    } catch (e) {
      return 'Không xác định';
    }

    return 'Không xác định';
  }
}
