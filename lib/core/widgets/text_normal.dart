import 'package:flutter/cupertino.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class TextNormal extends StatelessWidget {
  final String data;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TextNormal(
      this.data, {
        super.key,
        this.color,
        this.textAlign,
        this.maxLines,
        this.overflow,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        fontSize: AppDimensions.fontNormal,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textPrimary,
        fontFamily: 'Roboto',
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}