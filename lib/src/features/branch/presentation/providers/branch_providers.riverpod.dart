import 'package:app_with_riverpod/main_exports.dart';
import 'package:app_with_riverpod/src/core/routes/routes_export.dart';
import 'package:app_with_riverpod/src/features/branch/data/repositories/branch_repo_impl.dart';
import 'package:app_with_riverpod/src/features/branch/data/sources/branch_api.dart';
import 'package:app_with_riverpod/src/features/branch/domain/repositories/branch_repo.dart';
import 'package:app_with_riverpod/src/features/branch/domain/usecase/branch_usecase.dart';
import 'package:app_with_riverpod/src/features/branch/presentation/providers/branch_notifier.dart';
import 'package:app_with_riverpod/src/features/branch/presentation/providers/state/branch_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final branchApiProvider = Provider<BranchApi>((ref) {
  final apiService = ref.read(baseApiServiceProvider);
  return BranchApi(apiService);
});

final branchUseCaseProvider = Provider<BranchUsecase>((ref) {
  final repository = ref.read(branchRepositoryProvider);
  return BranchUsecase(repository);
});

/// Repository Provider
final branchRepositoryProvider = Provider<BranchRepo>((ref) {
  final api = ref.read(branchApiProvider);
  return BranchRepoImpl(api);
});

final branchesProvider = StateNotifierProvider<BranchNotifier, BranchState>((
  ref,
) {
  final useCase = ref.read(branchUseCaseProvider);

  return BranchNotifier(useCase);
});
