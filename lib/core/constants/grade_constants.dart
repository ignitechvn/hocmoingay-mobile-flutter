enum EGradeLevel {
  GRADE_1('GRADE_1'),
  GRADE_2('GRADE_2'),
  GRADE_3('GRADE_3'),
  GRADE_4('GRADE_4'),
  GRADE_5('GRADE_5'),
  GRADE_6('GRADE_6'),
  GRADE_7('GRADE_7'),
  GRADE_8('GRADE_8'),
  GRADE_9('GRADE_9'),
  GRADE_10('GRADE_10'),
  GRADE_11('GRADE_11'),
  GRADE_12('GRADE_12'),
  UNIVERSITY('UNIVERSITY'),
  COLLEGE('COLLEGE'),
  OTHER('OTHER');

  const EGradeLevel(this.value);
  final String value;

  static EGradeLevel fromString(String value) {
    return EGradeLevel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => EGradeLevel.GRADE_1,
    );
  }

  String get label {
    switch (this) {
      case EGradeLevel.GRADE_1:
        return 'Lớp 1';
      case EGradeLevel.GRADE_2:
        return 'Lớp 2';
      case EGradeLevel.GRADE_3:
        return 'Lớp 3';
      case EGradeLevel.GRADE_4:
        return 'Lớp 4';
      case EGradeLevel.GRADE_5:
        return 'Lớp 5';
      case EGradeLevel.GRADE_6:
        return 'Lớp 6';
      case EGradeLevel.GRADE_7:
        return 'Lớp 7';
      case EGradeLevel.GRADE_8:
        return 'Lớp 8';
      case EGradeLevel.GRADE_9:
        return 'Lớp 9';
      case EGradeLevel.GRADE_10:
        return 'Lớp 10';
      case EGradeLevel.GRADE_11:
        return 'Lớp 11';
      case EGradeLevel.GRADE_12:
        return 'Lớp 12';
      case EGradeLevel.UNIVERSITY:
        return 'Đại học';
      case EGradeLevel.COLLEGE:
        return 'Cao đẳng';
      case EGradeLevel.OTHER:
        return 'Khác';
    }
  }

  @override
  String toString() => value;
}
