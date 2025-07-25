enum EExamStatus {
  SCHEDULED('SCHEDULED'),
  OPEN('OPEN'),
  CLOSED('CLOSED');

  const EExamStatus(this.value);
  final String value;

  static EExamStatus fromString(String value) {
    return EExamStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => EExamStatus.SCHEDULED,
    );
  }
}

const Map<EExamStatus, String> EXAM_STATUS_LABELS = {
  EExamStatus.SCHEDULED: 'Đã lên lịch',
  EExamStatus.OPEN: 'Đang mở',
  EExamStatus.CLOSED: 'Đã đóng',
};

const Map<EExamStatus, int> EXAM_STATUS_BACKGROUND_COLOR = {
  EExamStatus.SCHEDULED: 0xFFECF4FE, // Light blue
  EExamStatus.OPEN: 0xFFE2F7F0, // Light green
  EExamStatus.CLOSED: 0xFFFDE9E9, // Light red
};
