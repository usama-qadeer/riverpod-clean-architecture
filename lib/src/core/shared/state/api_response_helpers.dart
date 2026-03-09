import 'package:app_with_riverpod/src/core/shared/state/api_responses.dart';
import 'package:app_with_riverpod/src/core/shared/state/status.dart';

extension ApiResponcesX<T> on ApiResponses<T> {
  bool get isIdle => status == Status.IDLE;
  bool get isLoading => status == Status.LOADING;
  bool get isSuccess => status == Status.SUCCESS;
  bool get isError => status == Status.ERROR;

  String get errorMessageSafe => message ?? "Something went wrong";
}
