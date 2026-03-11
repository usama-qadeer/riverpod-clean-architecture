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

  String get readableMessage {
    if (errors != null && errors!.isNotEmpty) {
      final firstList = errors!.values.first;
      if (firstList.isNotEmpty) {
        return firstList.first;
      }
    }
    return message ?? "Something went wrong";
  }
}
