class UserModel {
  final int id;
  final String name;
  final String email;
  final String? address;
  final DateTime? emailVerifiedAt;
  final String? image;
  final String? bio;
  final String? number;
  final String? role;
  final String? status;
  final String? onlineStatus;
  final String? onrideStatus;
  final String? loginRole;
  final String? universityName;
  final String? departmentName;
  final String? universityYear;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.address,
    this.emailVerifiedAt,
    this.image,
    this.bio,
    this.number,
    this.role,
    this.status,
    this.onlineStatus,
    this.onrideStatus,
    this.loginRole,
    this.universityName,
    this.departmentName,
    this.universityYear,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      image: json['image'],
      bio: json['bio'],
      number: json['number'],
      role: json['role']?.toString(),
      status: json['status']?.toString(),
      onlineStatus: json['online_status']?.toString(),
      onrideStatus: json['onride_status']?.toString(),
      loginRole: json['login_role']?.toString(),
      universityName: json['university_name'],
      departmentName: json['department_name'],
      universityYear: json['university_year']?.toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'image': image,
      'bio': bio,
      'number': number,
      'role': role,
      'status': status,
      'online_status': onlineStatus,
      'onride_status': onrideStatus,
      'login_role': loginRole,
      'university_name': universityName,
      'department_name': departmentName,
      'university_year': universityYear,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
