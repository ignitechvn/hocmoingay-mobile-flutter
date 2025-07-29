import '../../../core/constants/subject_constants.dart';

// Response DTOs
class TeacherProfileResponseDto {
  final String id;
  final String userId;
  final String? degree;
  final int? graduationYear;
  final String? university;
  final String? major;
  final int? yearsOfTeaching;
  final String? experienceDescription;
  final String? personalWebsite;
  final String? bio;
  final List<TeacherSubjectResponseDto>? subjects;
  final List<TeacherCertificationResponseDto>? certifications;
  final List<TeacherAchievementResponseDto>? achievements;
  final DateTime createdDate;
  final DateTime? updateDate;

  const TeacherProfileResponseDto({
    required this.id,
    required this.userId,
    this.degree,
    this.graduationYear,
    this.university,
    this.major,
    this.yearsOfTeaching,
    this.experienceDescription,
    this.personalWebsite,
    this.bio,
    this.subjects,
    this.certifications,
    this.achievements,
    required this.createdDate,
    this.updateDate,
  });

  factory TeacherProfileResponseDto.fromJson(Map<String, dynamic> json) {
    return TeacherProfileResponseDto(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      degree: json['degree'],
      graduationYear: json['graduationYear'],
      university: json['university'],
      major: json['major'],
      yearsOfTeaching: json['yearsOfTeaching'],
      experienceDescription: json['experienceDescription'],
      personalWebsite: json['personalWebsite'],
      bio: json['bio'],
      subjects: json['subjects'] != null
          ? (json['subjects'] as List)
                .map((subject) => TeacherSubjectResponseDto.fromJson(subject))
                .toList()
          : null,
      certifications: json['certifications'] != null
          ? (json['certifications'] as List)
                .map((cert) => TeacherCertificationResponseDto.fromJson(cert))
                .toList()
          : null,
      achievements: json['achievements'] != null
          ? (json['achievements'] as List)
                .map(
                  (achievement) =>
                      TeacherAchievementResponseDto.fromJson(achievement),
                )
                .toList()
          : null,
      createdDate: DateTime.parse(json['createdDate']),
      updateDate: json['updateDate'] != null
          ? DateTime.parse(json['updateDate'])
          : null,
    );
  }
}

class TeacherSubjectResponseDto {
  final String id;
  final String subject;
  final DateTime createdDate;

  const TeacherSubjectResponseDto({
    required this.id,
    required this.subject,
    required this.createdDate,
  });

  factory TeacherSubjectResponseDto.fromJson(Map<String, dynamic> json) {
    return TeacherSubjectResponseDto(
      id: json['id'] ?? '',
      subject: json['subject'] ?? '',
      createdDate: DateTime.parse(json['createdDate']),
    );
  }
}

class TeacherCertificationResponseDto {
  final String id;
  final String name;
  final String? issuingOrganization;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final String? description;
  final String? imageUrl;
  final DateTime createdDate;
  final DateTime? updateDate;

  const TeacherCertificationResponseDto({
    required this.id,
    required this.name,
    this.issuingOrganization,
    this.issueDate,
    this.expiryDate,
    this.description,
    this.imageUrl,
    required this.createdDate,
    this.updateDate,
  });

  factory TeacherCertificationResponseDto.fromJson(Map<String, dynamic> json) {
    return TeacherCertificationResponseDto(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      issuingOrganization: json['issuingOrganization'],
      issueDate: json['issueDate'] != null
          ? DateTime.parse(json['issueDate'])
          : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      description: json['description'],
      imageUrl: json['imageUrl'],
      createdDate: DateTime.parse(json['createdDate']),
      updateDate: json['updateDate'] != null
          ? DateTime.parse(json['updateDate'])
          : null,
    );
  }
}

class TeacherAchievementResponseDto {
  final String id;
  final String title;
  final int year;
  final String? description;
  final String? imageUrl;
  final DateTime createdDate;
  final DateTime? updateDate;

  const TeacherAchievementResponseDto({
    required this.id,
    required this.title,
    required this.year,
    this.description,
    this.imageUrl,
    required this.createdDate,
    this.updateDate,
  });

  factory TeacherAchievementResponseDto.fromJson(Map<String, dynamic> json) {
    return TeacherAchievementResponseDto(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      year: json['year'] ?? 0,
      description: json['description'],
      imageUrl: json['imageUrl'],
      createdDate: DateTime.parse(json['createdDate']),
      updateDate: json['updateDate'] != null
          ? DateTime.parse(json['updateDate'])
          : null,
    );
  }
}

// Create DTOs
class CreateTeacherProfileDto {
  final String? degree;
  final int? graduationYear;
  final String? university;
  final String? major;
  final int? yearsOfTeaching;
  final String? experienceDescription;
  final String? personalWebsite;
  final String? bio;
  final List<CreateTeacherSubjectDto>? subjects;
  final List<CreateTeacherCertificationDto>? certifications;
  final List<CreateTeacherAchievementDto>? achievements;

  const CreateTeacherProfileDto({
    this.degree,
    this.graduationYear,
    this.university,
    this.major,
    this.yearsOfTeaching,
    this.experienceDescription,
    this.personalWebsite,
    this.bio,
    this.subjects,
    this.certifications,
    this.achievements,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (degree != null) data['degree'] = degree;
    if (graduationYear != null) data['graduationYear'] = graduationYear;
    if (university != null) data['university'] = university;
    if (major != null) data['major'] = major;
    if (yearsOfTeaching != null) data['yearsOfTeaching'] = yearsOfTeaching;
    if (experienceDescription != null)
      data['experienceDescription'] = experienceDescription;
    if (personalWebsite != null) data['personalWebsite'] = personalWebsite;
    if (bio != null) data['bio'] = bio;
    if (subjects != null)
      data['subjects'] = subjects!.map((s) => s.toJson()).toList();
    if (certifications != null)
      data['certifications'] = certifications!.map((c) => c.toJson()).toList();
    if (achievements != null)
      data['achievements'] = achievements!.map((a) => a.toJson()).toList();
    return data;
  }
}

class CreateTeacherSubjectDto {
  final String subject;

  const CreateTeacherSubjectDto({required this.subject});

  Map<String, dynamic> toJson() => {'subject': subject};
}

class CreateTeacherCertificationDto {
  final String name;
  final String? issuingOrganization;
  final String? issueDate;
  final String? expiryDate;
  final String? description;
  final String? imageUrl;

  const CreateTeacherCertificationDto({
    required this.name,
    this.issuingOrganization,
    this.issueDate,
    this.expiryDate,
    this.description,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'name': name};
    if (issuingOrganization != null)
      data['issuingOrganization'] = issuingOrganization;
    if (issueDate != null) data['issueDate'] = issueDate;
    if (expiryDate != null) data['expiryDate'] = expiryDate;
    if (description != null) data['description'] = description;
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    return data;
  }
}

class CreateTeacherAchievementDto {
  final String title;
  final int year;
  final String? description;
  final String? imageUrl;

  const CreateTeacherAchievementDto({
    required this.title,
    required this.year,
    this.description,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'title': title, 'year': year};
    if (description != null) data['description'] = description;
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    return data;
  }
}

// Update DTOs
class UpdateTeacherProfileDto {
  final String? degree;
  final int? graduationYear;
  final String? university;
  final String? major;
  final int? yearsOfTeaching;
  final String? experienceDescription;
  final String? personalWebsite;
  final String? bio;
  final List<UpdateTeacherSubjectDto>? subjects;
  final List<UpdateTeacherCertificationDto>? certifications;
  final List<UpdateTeacherAchievementDto>? achievements;

  const UpdateTeacherProfileDto({
    this.degree,
    this.graduationYear,
    this.university,
    this.major,
    this.yearsOfTeaching,
    this.experienceDescription,
    this.personalWebsite,
    this.bio,
    this.subjects,
    this.certifications,
    this.achievements,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (degree != null) data['degree'] = degree;
    if (graduationYear != null) data['graduationYear'] = graduationYear;
    if (university != null) data['university'] = university;
    if (major != null) data['major'] = major;
    if (yearsOfTeaching != null) data['yearsOfTeaching'] = yearsOfTeaching;
    if (experienceDescription != null)
      data['experienceDescription'] = experienceDescription;
    if (personalWebsite != null) data['personalWebsite'] = personalWebsite;
    if (bio != null) data['bio'] = bio;
    if (subjects != null)
      data['subjects'] = subjects!.map((s) => s.toJson()).toList();
    if (certifications != null)
      data['certifications'] = certifications!.map((c) => c.toJson()).toList();
    if (achievements != null)
      data['achievements'] = achievements!.map((a) => a.toJson()).toList();
    return data;
  }
}

class UpdateTeacherSubjectDto {
  final String? subject;

  const UpdateTeacherSubjectDto({this.subject});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (subject != null) data['subject'] = subject;
    return data;
  }
}

class UpdateTeacherCertificationDto {
  final String? name;
  final String? issuingOrganization;
  final String? issueDate;
  final String? expiryDate;
  final String? description;
  final String? imageUrl;

  const UpdateTeacherCertificationDto({
    this.name,
    this.issuingOrganization,
    this.issueDate,
    this.expiryDate,
    this.description,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (issuingOrganization != null)
      data['issuingOrganization'] = issuingOrganization;
    if (issueDate != null) data['issueDate'] = issueDate;
    if (expiryDate != null) data['expiryDate'] = expiryDate;
    if (description != null) data['description'] = description;
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    return data;
  }
}

class UpdateTeacherAchievementDto {
  final String? title;
  final int? year;
  final String? description;
  final String? imageUrl;

  const UpdateTeacherAchievementDto({
    this.title,
    this.year,
    this.description,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (title != null) data['title'] = title;
    if (year != null) data['year'] = year;
    if (description != null) data['description'] = description;
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    return data;
  }
}
