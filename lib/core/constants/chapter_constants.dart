enum EChapterStatus {
  SCHEDULED('SCHEDULED'),
  OPEN('OPEN'),
  CLOSED('CLOSED'),
  CANCELED('CANCELED');

  const EChapterStatus(this.value);
  final String value;

  static EChapterStatus fromString(String value) {
    return EChapterStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => EChapterStatus.SCHEDULED,
    );
  }

  @override
  String toString() => value;
}
