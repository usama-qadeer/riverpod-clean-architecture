class BranchModel {
  final int id;
  final String name;
  final int code;
  final String email;
  final String phone;
  final String? image;
  final String? bio;
  final String percentage;
  final String address;
  final int countryId;
  final int cityId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  BranchModel({
    required this.id,
    required this.name,
    required this.code,
    required this.email,
    required this.phone,
    this.image,
    this.bio,
    required this.percentage,
    required this.address,
    required this.countryId,
    required this.cityId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      bio: json['bio'],
      percentage: json['percentage'],
      address: json['address'],
      countryId: json['country_id'],
      cityId: json['city_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'email': email,
      'phone': phone,
      'image': image,
      'bio': bio,
      'percentage': percentage,
      'address': address,
      'country_id': countryId,
      'city_id': cityId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
