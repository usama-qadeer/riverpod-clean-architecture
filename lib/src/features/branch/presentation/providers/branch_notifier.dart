import 'package:app_with_riverpod/src/core/logger/logger.dart';
import 'package:app_with_riverpod/src/features/branch/domain/usecase/branch_usecase.dart';
import 'package:app_with_riverpod/src/features/branch/presentation/providers/state/branch_state.dart';
import 'package:riverpod/legacy.dart';

class BranchNotifier extends StateNotifier<BranchState> {
  final BranchUsecase branchUsecase;
  BranchNotifier(this.branchUsecase) : super(BranchState());

  Future<void> getBranchData() async {
    state = state.copyWith(isLoading: true, branches: [], error: null);
    try {
      final result = await branchUsecase.call();
      state = state.copyWith(branches: result, error: null, isLoading: false);
    } catch (e, st) {
      AppLogger.e("Branch Error: $e\n$st");
      state = state.copyWith(
        branches: [],
        error: e.toString(),
        isLoading: false,
      );
    }
  }
}
