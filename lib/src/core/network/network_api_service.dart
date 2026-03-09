import 'dart:io';
import 'package:app_with_riverpod/main_exports.dart';
import 'package:app_with_riverpod/src/core/constants/api_urls.dart';
import 'package:app_with_riverpod/src/core/error/api_error.dart';
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
    } catch (_) {
      throw const UnknownException("Unexpected error");
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
    } catch (_) {
      throw const UnknownException("Unexpected error");
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
    } catch (_) {
      throw const UnknownException("Unexpected error");
    }
  }

  /// ===============================
  /// 🔹 Response Handler
  /// ===============================
  dynamic _handleResponse(Response response) {
    final code = response.statusCode ?? 0;

    if (code == 200 || code == 201) {
      return response.data;
    }

    final message = _extractMessage(response.data);

    if (code == 400 || code == 422) {
      throw ValidationException(message, code: code);
    }

    if (code == 401 || code == 403) {
      throw UnauthorizedException(
        message.isEmpty ? "Unauthorized" : message,
        code: code,
      );
    }

    throw ServerException("Server error ($code): $message", code: code);
  }

  /// ===============================
  /// 🔹 Extract Error Message
  /// ===============================
  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final error = ApiErrorModel.fromJson(data);
      return error.readableMessage;
    }
    if (data is String) {
      return data;
    }
    return "Something went wrong";
  }

  /// ===============================
  /// 🔹 Dio Error Handler
  /// ===============================
  AppException _handleDioError(DioException e) {
    if (e.error is SocketException) {
      return const NoInternetException("Please check your internet connection");
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const ServerException(
        "Connection timeout. Please try again later.",
      );
    }

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

      return ServerException(msg, code: code);
    }

    return UnknownException("Unexpected error: ${e.message}");
  }
}
