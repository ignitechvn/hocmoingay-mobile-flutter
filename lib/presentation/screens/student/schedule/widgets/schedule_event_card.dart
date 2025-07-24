import 'package:flutter/material.dart';

import '../../../../../core/constants/classroom_constants.dart';
import '../../../../../core/constants/subject_constants.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../domain/entities/classroom.dart';

class ScheduleEventCard extends StatelessWidget {
  const ScheduleEventCard({required this.classroom, super.key});
  final ClassroomStudent classroom;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    height: double.infinity,
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: _getSubjectColor(classroom.code),
      borderRadius: BorderRadius.circular(6),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Class name (moved to top)
        Expanded(
          child: Text(
            classroom.name,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Subject code (moved to middle)
        Text(
          SubjectLabels.getLabel(classroom.code),
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        // Grade level
        Text(
          classroom.grade.label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );

  Color _getSubjectColor(ESubjectCode subjectCode) {
    switch (subjectCode) {
      case ESubjectCode.MATH:
        return const Color(0xFF9C27B0); // Purple
      case ESubjectCode.PHYSICS:
        return const Color(0xFF2196F3); // Blue
      case ESubjectCode.CHEMISTRY:
        return const Color(0xFF4CAF50); // Green
      case ESubjectCode.ENGLISH:
        return const Color(0xFFE91E63); // Pink
      case ESubjectCode.INFORMATION_TECHOLOGY:
        return const Color(0xFF3F51B5);
    }
  }
}
