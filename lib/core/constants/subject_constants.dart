enum ESubjectCode {
  MATH('MATH'),
  PHYSICS('PHYSICS'),
  CHEMISTRY('CHEMISTRY'),
  ENGLISH('ENGLISH'),
  INFORMATION_TECHOLOGY('INFORMATION_TECHOLOGY');

  const ESubjectCode(this.value);
  final String value;

  static ESubjectCode fromString(String value) {
    return ESubjectCode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ESubjectCode.MATH,
    );
  }

  @override
  String toString() => value;
}
