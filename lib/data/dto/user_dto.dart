
import '../../domain/entities/user.dart';

class UserDto {
  final String id;
  final String fullName;
  final String phone;
  final String address;
  final String grade;
  final String? password;

  UserDto({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.grade,
    this.password
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json['id'],
    fullName: json['fullName'],
    phone: json['phone'],
    address: json['address'],
    grade: json['grade'],
    password: json['password'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'phone': phone,
    'address': address,
    'grade': grade,
  };

  User toEntity() => User(
    id: id,
    fullName: fullName,
    phone: phone,
    address: address,
    grade: grade,
  );

  factory UserDto.fromEntity(User user) => UserDto(
    id: user.id,
    fullName: user.fullName,
    phone: user.phone,
    address: user.address,
    grade: user.grade,
  );
}
