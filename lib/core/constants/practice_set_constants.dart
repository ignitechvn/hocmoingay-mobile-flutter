enum EPracticeSetStatus {
  SCHEDULED('SCHEDULED'),
  OPEN('OPEN'),
  CLOSED('CLOSED');

  const EPracticeSetStatus(this.value);
  final String value;

  static EPracticeSetStatus fromString(String value) {
    return EPracticeSetStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => EPracticeSetStatus.SCHEDULED,
    );
  }
}

// Background colors for practice set status
const Map<EPracticeSetStatus, int> PRACTICE_SET_STATUS_BACKGROUND_COLOR = {
  EPracticeSetStatus.SCHEDULED: 0xFFECF4FE, // Light blue
  EPracticeSetStatus.OPEN: 0xFFE2F7F0, // Light green
  EPracticeSetStatus.CLOSED: 0xFFFDE9E9, // Light red
}; 