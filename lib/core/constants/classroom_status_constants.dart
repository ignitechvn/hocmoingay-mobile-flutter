enum EClassroomStatus {
  ENROLLING('ENROLLING'),
  ONGOING('ONGOING'),
  FINISHED('FINISHED'),
  CANCELED('CANCELED');

  const EClassroomStatus(this.value);
  final String value;

  static EClassroomStatus fromString(String value) {
    return EClassroomStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => EClassroomStatus.ENROLLING,
    );
  }

  @override
  String toString() => value;
}
