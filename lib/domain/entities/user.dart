import '../../core/constants/app_constants.dart';
import '../../core/constants/grade_constants.dart';

class User {
  final String id;
  final String fullName;
  final String phone;
  final String address;
  final String? email;
  final Role role;
  final EGradeLevel? grade;
  final Gender gender;

  const User({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.address,
    this.email,
    required this.role,
    this.grade,
    required this.gender,
  });
}
