enum EQuestionType {
  MULTIPLE_CHOICE('multiple-choice'),
  FILL_IN_THE_BLANK('fill-in-the-blank'),
  CLOZE_TEST('cloze-test'),
  SENTENCE_REWRITING('sentence-rewriting');

  const EQuestionType(this.value);
  final String value;

  static EQuestionType fromString(String value) {
    return EQuestionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => EQuestionType.MULTIPLE_CHOICE,
    );
  }

  @override
  String toString() => value;
}

enum EDifficulty {
  VERY_EASY('VERY_EASY'),
  EASY('EASY'),
  MEDIUM('MEDIUM'),
  HARD('HARD'),
  VERY_HARD('VERY_HARD');

  const EDifficulty(this.value);
  final String value;

  static EDifficulty fromString(String value) {
    return EDifficulty.values.firstWhere(
      (e) => e.value == value,
      orElse: () => EDifficulty.MEDIUM,
    );
  }

  @override
  String toString() => value;
}
