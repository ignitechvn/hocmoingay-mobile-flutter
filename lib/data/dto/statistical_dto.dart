class StudentScoreDto {
  final String studentId;
  final String fullName;
  final double score;

  const StudentScoreDto({
    required this.studentId,
    required this.fullName,
    required this.score,
  });

  factory StudentScoreDto.fromJson(Map<String, dynamic> json) {
    return StudentScoreDto(
      studentId: json['studentId'] ?? '',
      fullName: json['fullName'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'studentId': studentId, 'fullName': fullName, 'score': score};
  }
}

// Chapter Detail Report DTO
class ChapterDetailReportDto {
  final String title;
  final String status;
  final int totalQuestions;
  final int answered;
  final int correctAnswers;
  final double studentScore;
  final double totalScore;

  const ChapterDetailReportDto({
    required this.title,
    required this.status,
    required this.totalQuestions,
    required this.answered,
    required this.correctAnswers,
    required this.studentScore,
    required this.totalScore,
  });

  factory ChapterDetailReportDto.fromJson(Map<String, dynamic> json) {
    return ChapterDetailReportDto(
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      totalQuestions: json['totalQuestions'] ?? 0,
      answered: json['answered'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      studentScore: (json['studentScore'] ?? 0).toDouble(),
      totalScore: (json['totalScore'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': status,
      'totalQuestions': totalQuestions,
      'answered': answered,
      'correctAnswers': correctAnswers,
      'studentScore': studentScore,
      'totalScore': totalScore,
    };
  }
}

// Practice Set Detail Report DTO
class PracticeSetDetailReportDto {
  final String title;
  final String status;
  final int totalQuestions;
  final int answered;
  final int correctAnswers;
  final double studentScore;
  final double totalScore;

  const PracticeSetDetailReportDto({
    required this.title,
    required this.status,
    required this.totalQuestions,
    required this.answered,
    required this.correctAnswers,
    required this.studentScore,
    required this.totalScore,
  });

  factory PracticeSetDetailReportDto.fromJson(Map<String, dynamic> json) {
    return PracticeSetDetailReportDto(
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      totalQuestions: json['totalQuestions'] ?? 0,
      answered: json['answered'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      studentScore: (json['studentScore'] ?? 0).toDouble(),
      totalScore: (json['totalScore'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': status,
      'totalQuestions': totalQuestions,
      'answered': answered,
      'correctAnswers': correctAnswers,
      'studentScore': studentScore,
      'totalScore': totalScore,
    };
  }
}

// Exam Detail Report DTO
class ExamDetailReportDto {
  final String title;
  final String status;
  final int totalQuestions;
  final int answered;
  final int correctAnswers;
  final double studentScore;
  final double totalScore;

  const ExamDetailReportDto({
    required this.title,
    required this.status,
    required this.totalQuestions,
    required this.answered,
    required this.correctAnswers,
    required this.studentScore,
    required this.totalScore,
  });

  factory ExamDetailReportDto.fromJson(Map<String, dynamic> json) {
    return ExamDetailReportDto(
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      totalQuestions: json['totalQuestions'] ?? 0,
      answered: json['answered'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      studentScore: (json['studentScore'] ?? 0).toDouble(),
      totalScore: (json['totalScore'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': status,
      'totalQuestions': totalQuestions,
      'answered': answered,
      'correctAnswers': correctAnswers,
      'studentScore': studentScore,
      'totalScore': totalScore,
    };
  }
}

// Student Progress Report DTO
class StudentProgressReportDto {
  final String studentId;
  final String fullName;
  final int ongoingChaptersCount;
  final int completedChaptersCount;
  final int totalChaptersCount;
  final int ongoingPracticeSetsCount;
  final int completedPracticeSetsCount;
  final int totalPracticeSetsCount;
  final int completedExamsCount;
  final List<ChapterDetailReportDto> chapterDetailReports;
  final List<PracticeSetDetailReportDto> practiceSetDetailReports;
  final List<ExamDetailReportDto> examDetailReports;
  final int totalExamsCount;
  final List<double> weeklyExamScores;
  final List<int> weeklyHardWork;

  const StudentProgressReportDto({
    required this.studentId,
    required this.fullName,
    required this.ongoingChaptersCount,
    required this.completedChaptersCount,
    required this.totalChaptersCount,
    required this.ongoingPracticeSetsCount,
    required this.completedPracticeSetsCount,
    required this.totalPracticeSetsCount,
    required this.completedExamsCount,
    required this.chapterDetailReports,
    required this.practiceSetDetailReports,
    required this.examDetailReports,
    required this.totalExamsCount,
    required this.weeklyExamScores,
    required this.weeklyHardWork,
  });

  factory StudentProgressReportDto.fromJson(Map<String, dynamic> json) {
    return StudentProgressReportDto(
      studentId: json['studentId'] ?? '',
      fullName: json['fullName'] ?? '',
      ongoingChaptersCount: json['ongoingChaptersCount'] ?? 0,
      completedChaptersCount: json['completedChaptersCount'] ?? 0,
      totalChaptersCount: json['totalChaptersCount'] ?? 0,
      ongoingPracticeSetsCount: json['ongoingPracticeSetsCount'] ?? 0,
      completedPracticeSetsCount: json['completedPracticeSetsCount'] ?? 0,
      totalPracticeSetsCount: json['totalPracticeSetsCount'] ?? 0,
      completedExamsCount: json['completedExamsCount'] ?? 0,
      chapterDetailReports:
          (json['chapterDetailReports'] as List<dynamic>?)
              ?.map((e) => ChapterDetailReportDto.fromJson(e))
              .toList() ??
          [],
      practiceSetDetailReports:
          (json['practiceSetDetailReports'] as List<dynamic>?)
              ?.map((e) => PracticeSetDetailReportDto.fromJson(e))
              .toList() ??
          [],
      examDetailReports:
          (json['examDetailReports'] as List<dynamic>?)
              ?.map((e) => ExamDetailReportDto.fromJson(e))
              .toList() ??
          [],
      totalExamsCount: json['totalExamsCount'] ?? 0,
      weeklyExamScores:
          (json['weeklyExamScores'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      weeklyHardWork:
          (json['weeklyHardWork'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'fullName': fullName,
      'ongoingChaptersCount': ongoingChaptersCount,
      'completedChaptersCount': completedChaptersCount,
      'totalChaptersCount': totalChaptersCount,
      'ongoingPracticeSetsCount': ongoingPracticeSetsCount,
      'completedPracticeSetsCount': completedPracticeSetsCount,
      'totalPracticeSetsCount': totalPracticeSetsCount,
      'completedExamsCount': completedExamsCount,
      'chapterDetailReports':
          chapterDetailReports.map((e) => e.toJson()).toList(),
      'practiceSetDetailReports':
          practiceSetDetailReports.map((e) => e.toJson()).toList(),
      'examDetailReports': examDetailReports.map((e) => e.toJson()).toList(),
      'totalExamsCount': totalExamsCount,
      'weeklyExamScores': weeklyExamScores,
      'weeklyHardWork': weeklyHardWork,
    };
  }
}

class ClassroomOverviewResponseDto {
  final String classroomName;
  final int totalLessonsPlanned;
  final int lessonsConducted;
  final int totalStudents;
  final int approvedStudents;
  final int pendingStudents;
  final int totalChapters;
  final int scheduledChapters;
  final int ongoingChapters;
  final int completedChapters;
  final int totalPracticeSets;
  final int scheduledPracticeSets;
  final int ongoingPracticeSets;
  final int completedPracticeSets;
  final int totalExams;
  final int scheduledExams;
  final int ongoingExams;
  final int completedExams;
  final List<StudentScoreDto> topExamAverageStudents;
  final List<StudentScoreDto> lowestExamAverageStudents;
  final List<StudentScoreDto> topAttendanceStudents;
  final List<StudentScoreDto> lowestAttendanceStudents;
  final List<int> weeklyAttendance;
  final List<double> weeklyExamAverage;

  const ClassroomOverviewResponseDto({
    required this.classroomName,
    required this.totalLessonsPlanned,
    required this.lessonsConducted,
    required this.totalStudents,
    required this.approvedStudents,
    required this.pendingStudents,
    required this.totalChapters,
    required this.scheduledChapters,
    required this.ongoingChapters,
    required this.completedChapters,
    required this.totalPracticeSets,
    required this.scheduledPracticeSets,
    required this.ongoingPracticeSets,
    required this.completedPracticeSets,
    required this.totalExams,
    required this.scheduledExams,
    required this.ongoingExams,
    required this.completedExams,
    required this.topExamAverageStudents,
    required this.lowestExamAverageStudents,
    required this.topAttendanceStudents,
    required this.lowestAttendanceStudents,
    required this.weeklyAttendance,
    required this.weeklyExamAverage,
  });

  factory ClassroomOverviewResponseDto.fromJson(Map<String, dynamic> json) {
    return ClassroomOverviewResponseDto(
      classroomName: json['classroomName'] ?? '',
      totalLessonsPlanned: json['totalLessonsPlanned'] ?? 0,
      lessonsConducted: json['lessonsConducted'] ?? 0,
      totalStudents: json['totalStudents'] ?? 0,
      approvedStudents: json['approvedStudents'] ?? 0,
      pendingStudents: json['pendingStudents'] ?? 0,
      totalChapters: json['totalChapters'] ?? 0,
      scheduledChapters: json['scheduledChapters'] ?? 0,
      ongoingChapters: json['ongoingChapters'] ?? 0,
      completedChapters: json['completedChapters'] ?? 0,
      totalPracticeSets: json['totalPracticeSets'] ?? 0,
      scheduledPracticeSets: json['scheduledPracticeSets'] ?? 0,
      ongoingPracticeSets: json['ongoingPracticeSets'] ?? 0,
      completedPracticeSets: json['completedPracticeSets'] ?? 0,
      totalExams: json['totalExams'] ?? 0,
      scheduledExams: json['scheduledExams'] ?? 0,
      ongoingExams: json['ongoingExams'] ?? 0,
      completedExams: json['completedExams'] ?? 0,
      topExamAverageStudents:
          (json['topExamAverageStudents'] as List<dynamic>?)
              ?.map((e) => StudentScoreDto.fromJson(e))
              .toList() ??
          [],
      lowestExamAverageStudents:
          (json['lowestExamAverageStudents'] as List<dynamic>?)
              ?.map((e) => StudentScoreDto.fromJson(e))
              .toList() ??
          [],
      topAttendanceStudents:
          (json['topAttendanceStudents'] as List<dynamic>?)
              ?.map((e) => StudentScoreDto.fromJson(e))
              .toList() ??
          [],
      lowestAttendanceStudents:
          (json['lowestAttendanceStudents'] as List<dynamic>?)
              ?.map((e) => StudentScoreDto.fromJson(e))
              .toList() ??
          [],
      weeklyAttendance:
          (json['weeklyAttendance'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      weeklyExamAverage:
          (json['weeklyExamAverage'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classroomName': classroomName,
      'totalLessonsPlanned': totalLessonsPlanned,
      'lessonsConducted': lessonsConducted,
      'totalStudents': totalStudents,
      'approvedStudents': approvedStudents,
      'pendingStudents': pendingStudents,
      'totalChapters': totalChapters,
      'scheduledChapters': scheduledChapters,
      'ongoingChapters': ongoingChapters,
      'completedChapters': completedChapters,
      'totalPracticeSets': totalPracticeSets,
      'scheduledPracticeSets': scheduledPracticeSets,
      'ongoingPracticeSets': ongoingPracticeSets,
      'completedPracticeSets': completedPracticeSets,
      'totalExams': totalExams,
      'scheduledExams': scheduledExams,
      'ongoingExams': ongoingExams,
      'completedExams': completedExams,
      'topExamAverageStudents':
          topExamAverageStudents.map((e) => e.toJson()).toList(),
      'lowestExamAverageStudents':
          lowestExamAverageStudents.map((e) => e.toJson()).toList(),
      'topAttendanceStudents':
          topAttendanceStudents.map((e) => e.toJson()).toList(),
      'lowestAttendanceStudents':
          lowestAttendanceStudents.map((e) => e.toJson()).toList(),
      'weeklyAttendance': weeklyAttendance,
      'weeklyExamAverage': weeklyExamAverage,
    };
  }
}

// Question Report DTO
class QuestionReportDto {
  final String id;
  final String content;
  final String type;
  final int difficulty;
  final double points;
  final List<String> options;
  final List<String> correctAnswers;
  final String explanation;
  final double correctRate;

  const QuestionReportDto({
    required this.id,
    required this.content,
    required this.type,
    required this.difficulty,
    required this.points,
    required this.options,
    required this.correctAnswers,
    required this.explanation,
    required this.correctRate,
  });

  factory QuestionReportDto.fromJson(Map<String, dynamic> json) {
    return QuestionReportDto(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] ?? '',
      difficulty: json['difficulty'] ?? 0,
      points: (json['points'] ?? 0).toDouble(),
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      correctAnswers:
          (json['correctAnswers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      explanation: json['explanation'] ?? '',
      correctRate: (json['correctRate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type,
      'difficulty': difficulty,
      'points': points,
      'options': options,
      'correctAnswers': correctAnswers,
      'explanation': explanation,
      'correctRate': correctRate,
    };
  }
}

// Chapter Report DTO
class ChapterReportDto {
  final List<QuestionReportDto> questions;

  const ChapterReportDto({required this.questions});

  factory ChapterReportDto.fromJson(Map<String, dynamic> json) {
    return ChapterReportDto(
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((e) => QuestionReportDto.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'questions': questions.map((e) => e.toJson()).toList()};
  }
}

// Practice Set Report DTO
class PracticeSetReportDto {
  final List<QuestionReportDto> questions;

  const PracticeSetReportDto({required this.questions});

  factory PracticeSetReportDto.fromJson(Map<String, dynamic> json) {
    return PracticeSetReportDto(
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((e) => QuestionReportDto.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'questions': questions.map((e) => e.toJson()).toList()};
  }
}

// Exam Report DTO
class ExamReportDto {
  final List<QuestionReportDto> questions;

  const ExamReportDto({required this.questions});

  factory ExamReportDto.fromJson(Map<String, dynamic> json) {
    return ExamReportDto(
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((e) => QuestionReportDto.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'questions': questions.map((e) => e.toJson()).toList()};
  }
}
