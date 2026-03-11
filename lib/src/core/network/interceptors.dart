import 'package:app_with_riverpod/src/core/error/app_exception.dart';
import 'package:app_with_riverpod/src/core/utils/internet_connection.dart';
import 'package:dio/dio.dart';
import '../logger/logger.dart';

typedef TokenProvider = Future<String?> Function();

class AppInterceptors extends Interceptor {
  final TokenProvider? tokenProvider;

  AppInterceptors({this.tokenProvider});
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final skipToken = options.extra['skipAuth'] == true;

      final hasInternet = await InternetChecker.hasConnection();
      if (!hasInternet) {
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
            error: const NoInternetException("No internet connection"),
          ),
        );
        return;
      }

      if (!skipToken && tokenProvider != null) {
        final token = await tokenProvider!.call();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }

      AppLogger.d("➡️ ${options.method} ${options.uri}");
      AppLogger.d("Headers: ${options.headers}");
      if (options.data is Map<String, dynamic>) {
        AppLogger.d("Body: ${AppLogger.maskSensitive(options.data)}");
      } else if (options.data != null) {
        AppLogger.d("Body: ${options.data}");
      }

      handler.next(options);
    } catch (e) {
      handler.reject(DioException(requestOptions: options, error: e));
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.d("✅ ${response.statusCode} ${response.requestOptions.uri}");
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e(
      "⛔ ${err.requestOptions.method} ${err.requestOptions.uri} failed",
      err,
      err.stackTrace,
    );
    handler.next(err);
  }
}
