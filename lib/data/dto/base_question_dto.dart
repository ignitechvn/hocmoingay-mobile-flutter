import '../../core/constants/question_constants.dart';

abstract class BaseQuestionResponseDto {
  final String id;
  final int questionNumber;
  final EQuestionType questionType;
  final EDifficulty difficulty;
  final List<ContentBlock> contentBlocks;
  final List<Answer> answers;
  final List<ContentBlock>? explanation;
  final int point;
  final DateTime createdAt;
  final DateTime updatedAt;

  BaseQuestionResponseDto({
    required this.id,
    required this.questionNumber,
    required this.questionType,
    required this.difficulty,
    required this.contentBlocks,
    required this.answers,
    this.explanation,
    required this.point,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionNumber': questionNumber,
      'questionType': questionType.value,
      'difficulty': difficulty.value,
      'contentBlocks': contentBlocks.map((block) => block.toJson()).toList(),
      'answers': answers.map((answer) => answer.toJson()).toList(),
      'explanation': explanation?.map((block) => block.toJson()).toList(),
      'point': point,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ContentBlock {
  final String type;
  final String content;
  final List<Equation>? equations;
  final String? url; // Thêm trường url cho image

  ContentBlock({
    required this.type,
    required this.content,
    this.equations,
    this.url,
  });

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    List<Equation>? equationsList;
    if (json['equations'] != null) {
      try {
        equationsList = (json['equations'] as List)
            .map((eq) => Equation.fromJson(eq as Map<String, dynamic>))
            .toList();
      } catch (e) {
        print('Error parsing equations: $e');
        equationsList = null;
      }
    }

    return ContentBlock(
      type: json['type']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      equations: equationsList,
      url: json['url']?.toString(), // Parse url field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
      'equations': equations?.map((eq) => eq.toJson()).toList(),
      'url': url, // Include url in JSON
    };
  }
}

class Equation {
  final String placeholder;
  final String latex;

  Equation({required this.placeholder, required this.latex});

  factory Equation.fromJson(Map<String, dynamic> json) {
    return Equation(
      placeholder: json['placeholder']?.toString() ?? '',
      latex: json['latex']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'placeholder': placeholder, 'latex': latex};
  }
}

class Answer {
  final String id;
  final String content;
  final List<Equation>? equations;
  final bool isCorrect;
  final int position;
  final Map<String, dynamic>? metadata;

  Answer({
    required this.id,
    required this.content,
    this.equations,
    required this.isCorrect,
    required this.position,
    this.metadata,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    List<Equation>? equationsList;
    if (json['equations'] != null) {
      try {
        equationsList = (json['equations'] as List)
            .map((eq) => Equation.fromJson(eq as Map<String, dynamic>))
            .toList();
      } catch (e) {
        print('Error parsing answer equations: $e');
        equationsList = null;
      }
    }

    Map<String, dynamic>? metadataMap;
    if (json['metadata'] != null) {
      try {
        metadataMap = json['metadata'] as Map<String, dynamic>;
      } catch (e) {
        print('Error parsing metadata: $e');
        metadataMap = null;
      }
    }

    return Answer(
      id: json['id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      equations: equationsList,
      isCorrect: json['isCorrect'] as bool? ?? false,
      position: json['position'] as int? ?? 0,
      metadata: metadataMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'equations': equations?.map((eq) => eq.toJson()).toList(),
      'isCorrect': isCorrect,
      'position': position,
      'metadata': metadata,
    };
  }
}
