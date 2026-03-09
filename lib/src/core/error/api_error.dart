class ApiErrorModel {
  final bool? success;
  final String? message;
  final Map<String, List<String>>? errors;

  ApiErrorModel({this.success, this.message, this.errors});

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    return ApiErrorModel(
      success: json['success'],
      message: json['message'],
      errors: json['errors'] != null
          ? Map<String, List<String>>.from(
              json['errors'].map(
                (key, value) => MapEntry(key, List<String>.from(value)),
              ),
            )
          : null,
    );
  }

  /// 🔥 readable message
  String get readableMessage {
    if (errors != null && errors!.isNotEmpty) {
      return errors!.values.first.first;
    }
    return message ?? "Something went wrong";
  }
}
