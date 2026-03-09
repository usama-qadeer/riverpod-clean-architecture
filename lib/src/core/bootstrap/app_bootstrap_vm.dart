import 'package:app_with_riverpod/src/core/bootstrap/bootstrap_state.dart';
import 'package:app_with_riverpod/src/features/branch/presentation/providers/branch_providers.riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AppBootstrapNotifier extends StateNotifier<AppBootstrapState> {
  final Ref ref;

  AppBootstrapNotifier(this.ref) : super(const AppBootstrapState());

  Future<void> load() async {
    if (state.loading || state.ready) return;

    state = state.copyWith(loading: true, error: null);

    try {
      await ref.read(branchesProvider.notifier).getBranchData();

      state = state.copyWith(loading: false, ready: true);
    } catch (e) {
      state = state.copyWith(loading: false, ready: false, error: e.toString());
    }
  }

  void reset() {
    state = const AppBootstrapState();
  }
}

final appBootstrapProvider =
    StateNotifierProvider<AppBootstrapNotifier, AppBootstrapState>((ref) {
      return AppBootstrapNotifier(ref);
    });
