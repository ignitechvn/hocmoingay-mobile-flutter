import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'dart:developer' as developer;

/// Widget để render một chuỗi LaTeX đơn lẻ
class MathRenderer extends StatelessWidget {
  final String latex;
  final double? fontSize;
  final Color? color;

  const MathRenderer({
    super.key,
    required this.latex,
    this.fontSize,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    try {
      // Loại bỏ khoảng trắng thừa ở đầu, cuối và giữa các từ
      String cleanLatex = latex.trim().replaceAll(RegExp(r'\s+'), ' ');

      // Xử lý cú pháp tập hợp với backslash
      if (cleanLatex.contains('\\\\')) {
        developer.log(
          'Set notation detected: $cleanLatex',
          name: 'MathRenderer',
        );

        // Thử các cách khác nhau để xử lý set notation
        final originalLatex = cleanLatex;

        // Cách 1: Thay thế \\ bằng \setminus
        cleanLatex = cleanLatex.replaceAll('\\\\', '\\setminus');

        // Cách 2: Nếu vẫn lỗi, thử với \backslash
        if (cleanLatex == originalLatex) {
          cleanLatex = cleanLatex.replaceAll('\\\\', '\\backslash');
        }

        developer.log('Converted to: $cleanLatex', name: 'MathRenderer');
      }

      developer.log(
        'Rendering LaTeX: $latex -> $cleanLatex',
        name: 'MathRenderer',
      );

      return Math.tex(
        cleanLatex,
        textStyle: TextStyle(
          fontSize: fontSize ?? 16,
          color: color ?? Colors.black,
        ),
        onErrorFallback: (error) {
          developer.log(
            'LaTeX rendering error: $error for latex: $cleanLatex',
            name: 'MathRenderer',
          );
          return Text(
            latex,
            style: TextStyle(
              fontSize: fontSize ?? 16,
              color: color ?? Colors.black,
            ),
          );
        },
      );
    } catch (e) {
      developer.log(
        'Exception in MathRenderer: $e for latex: $latex',
        name: 'MathRenderer',
      );
      // Fallback to text if LaTeX rendering fails
      return Text(
        latex,
        style: TextStyle(
          fontSize: fontSize ?? 16,
          color: color ?? Colors.black,
        ),
      );
    }
  }
}

/// Widget để render nội dung hỗn hợp (text + LaTeX)
class RichMathContent extends StatelessWidget {
  final String content;
  final List<Map<String, dynamic>>? equations;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;

  const RichMathContent({
    super.key,
    required this.content,
    this.equations,
    this.fontSize,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    try {
      developer.log(
        'RichMathContent: Rendering content with ${equations?.length ?? 0} equations',
        name: 'RichMathContent',
      );

      if (equations == null || equations!.isEmpty) {
        developer.log(
          'RichMathContent: No equations, using plain text',
          name: 'RichMathContent',
        );
        return Text(
          content,
          style: TextStyle(
            fontSize: fontSize ?? 16,
            color: color ?? Colors.black,
            fontWeight: fontWeight,
          ),
        );
      }

      // Tạo danh sách các phần tử để render
      final List<Widget> widgets = [];
      String remainingContent = content;

      // Sắp xếp equations theo thứ tự xuất hiện trong content
      final sortedEquations = List<Map<String, dynamic>>.from(equations!);
      sortedEquations.sort((a, b) {
        final placeholderA = a['placeholder'] as String? ?? '';
        final placeholderB = b['placeholder'] as String? ?? '';
        return content
            .indexOf('{{$placeholderA}}')
            .compareTo(content.indexOf('{{$placeholderB}}'));
      });

      developer.log(
        'RichMathContent: Sorted equations: ${sortedEquations.map((e) => '${e['placeholder']}: ${e['latex']}').join(', ')}',
        name: 'RichMathContent',
      );

      // Xử lý từng equation
      for (final equation in sortedEquations) {
        final placeholder = equation['placeholder'] as String? ?? '';
        final latex = equation['latex'] as String? ?? '';
        final placeholderPattern = '{{$placeholder}}';

        developer.log(
          'RichMathContent: Processing equation $placeholder: $latex',
          name: 'RichMathContent',
        );

        final parts = remainingContent.split(placeholderPattern);
        if (parts.length == 2) {
          // Thêm text trước equation
          if (parts[0].isNotEmpty) {
            widgets.add(
              Text(
                parts[0],
                style: TextStyle(
                  fontSize: fontSize ?? 16,
                  color: color ?? Colors.black,
                  fontWeight: fontWeight,
                ),
              ),
            );
          }

          // Thêm equation
          widgets.add(
            MathRenderer(latex: latex, fontSize: fontSize, color: color),
          );

          // Cập nhật remaining content
          remainingContent = parts[1];
        }
      }

      // Thêm phần text còn lại
      if (remainingContent.isNotEmpty) {
        widgets.add(
          Text(
            remainingContent,
            style: TextStyle(
              fontSize: fontSize ?? 16,
              color: color ?? Colors.black,
              fontWeight: fontWeight,
            ),
          ),
        );
      }

      developer.log(
        'RichMathContent: Successfully rendered with ${widgets.length} widgets',
        name: 'RichMathContent',
      );
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: widgets,
      );
    } catch (e) {
      developer.log(
        'RichMathContent: Exception during rendering: $e',
        name: 'RichMathContent',
      );
      // Fallback to plain text if rendering fails
      return Text(
        content,
        style: TextStyle(
          fontSize: fontSize ?? 16,
          color: color ?? Colors.black,
          fontWeight: fontWeight,
        ),
      );
    }
  }
}

/// Test method để kiểm tra LaTeX rendering
class MathRendererTest {
  static void testBasicLatex() {
    final testCases = [
      'x = 0',
      'y + 2 = 5',
      'a * b = c',
      'x \\leq 10',
      'y \\geq 0',
      'z \\neq 5',
    ];

    for (final testCase in testCases) {
      developer.log('Testing LaTeX: $testCase', name: 'MathRendererTest');
    }
  }
}
