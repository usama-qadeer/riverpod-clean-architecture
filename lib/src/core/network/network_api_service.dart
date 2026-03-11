import 'dart:io';
import 'package:app_with_riverpod/main_exports.dart';
import 'package:app_with_riverpod/src/core/constants/api_urls.dart';
import 'package:app_with_riverpod/src/core/error/api_error.dart';
import 'package:app_with_riverpod/src/core/logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error/app_exception.dart';
import 'base_api_service.dart';
import 'interceptors.dart';

/// ===============================
/// 🔹 Dio Provider
/// ===============================
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: ApiUrls.baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: AppConfig.defaultHeaders,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );
});

/// ===============================
/// 🔹 BaseApiService Provider
/// ===============================

final baseApiServiceProvider = Provider<BaseApiService>((ref) {
  final dio = ref.read(dioProvider);

  return NetworkApiService(
    dio: dio,
    tokenProvider: () async {
      return AppLocalStorage.getUserToken();
    },
  );
});

/// ===============================
/// 🔹 Implementation
/// ===============================
class NetworkApiService implements BaseApiService {
  final Dio _dio;

  NetworkApiService({required Dio dio, TokenProvider? tokenProvider})
    : _dio = dio {
    _dio.interceptors.add(AppInterceptors(tokenProvider: tokenProvider));
  }

  @override
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      final response = await _dio.get(url, options: Options(headers: headers));

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.e("Unexpected error in post: $e\n$st");
      throw UnknownException("Unexpected error: $e");
    }
  }

  @override
  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: body,
        options: Options(headers: headers),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.e("Unexpected error in post: $e\n$st");
      throw UnknownException("Unexpected error: $e");
    }
  }

  @override
  Future<dynamic> postMultipart(
    String url, {
    Map<String, String>? headers,
    required FormData formData,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.e("Unexpected error in post: $e\n$st");
      throw UnknownException("Unexpected error: $e");
    }
  }

  /// ===============================
  /// 🔹 Response Handler
  /// ===============================
  dynamic _handleResponse(Response response) {
    final code = response.statusCode ?? 0;

    // Success
    if (code == 200 || code == 201) {
      return response.data;
    }

    // Extract message
    final message = _extractMessage(response.data);

    // Validation / Bad request
    if (code == 400 || code == 422) {
      throw ValidationException(message, code: code);
    }

    // Unauthorized
    if (code == 401 || code == 403) {
      throw UnauthorizedException(
        message.isEmpty ? "Unauthorized" : message,
        code: code,
      );
    }

    // **404 Not Found** → treat as validation / server error
    if (code == 404) {
      throw ValidationException(
        message.isEmpty ? "Resource not found" : message,
        code: code,
      );
    }

    // Any other server error
    throw ServerException("Server error ($code): $message", code: code);
  }

  /// ===============================
  /// 🔹 Extract Error Message
  /// ===============================
  String _extractMessage(dynamic data) {
    try {
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        final error = ApiErrorModel.fromJson(map);
        return error.readableMessage;
      }

      if (data is String) {
        return data;
      }

      return "Something went wrong";
    } catch (e, st) {
      AppLogger.e("_extractMessage error: $e\n$st");
      return "Something went wrong";
    }
  }

  /// ===============================
  /// 🔹 Dio Error Handler
  /// ===============================
  AppException _handleDioError(DioException e) {
    // 1) Pure internet/socket issues
    if (e.error is SocketException) {
      return const NoInternetException("No internet connection");
    }

    // 2) Dio network connection issue
    if (e.type == DioExceptionType.connectionError) {
      return const NoInternetException("No internet connection");
    }

    // 3) Often internet drops in middle of request come here
    if (e.type == DioExceptionType.unknown) {
      final errorString = e.error?.toString().toLowerCase() ?? '';
      final messageString = e.message?.toLowerCase() ?? '';

      if (errorString.contains('socketexception') ||
          errorString.contains('failed host lookup') ||
          errorString.contains('network is unreachable') ||
          errorString.contains('connection aborted') ||
          messageString.contains('socketexception') ||
          messageString.contains('failed host lookup')) {
        return const NoInternetException("No internet connection");
      }
    }

    // 4) Timeout
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const ServerException(
        "Connection timeout. Please try again later.",
      );
    }

    // 5) Server response
    final res = e.response;
    if (res != null) {
      final code = res.statusCode ?? 0;
      final msg = _extractMessage(res.data);

      if (code == 400 || code == 422) {
        return ValidationException(msg, code: code);
      }

      if (code == 401 || code == 403) {
        return UnauthorizedException(msg, code: code);
      }

      if (code == 404) {
        return ValidationException(
          msg.isEmpty ? "Resource not found" : msg,
          code: code,
        );
      }

      return ServerException(msg.isEmpty ? "Server error" : msg, code: code);
    }

    // 6) Fallback
    return const UnknownException("Something went wrong");
  }
}
