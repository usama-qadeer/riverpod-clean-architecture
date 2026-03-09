// ignore_for_file: file_names

import 'auth_model.dart';

class LoginResponseModel {
  final UserModel? userDetails;
  final dynamic restaurantData;
  final String token;
  final String message;
  final int status;

  const LoginResponseModel({
    required this.userDetails,
    required this.restaurantData,
    required this.token,
    required this.message,
    required this.status,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      userDetails: json['userDetails'] != null
          ? UserModel.fromJson(json['userDetails'])
          : null,
      restaurantData: json['restaurant data'],
      token: json['token'] ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}
