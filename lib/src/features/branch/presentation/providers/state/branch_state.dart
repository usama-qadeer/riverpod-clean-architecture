import 'package:app_with_riverpod/src/features/branch/data/model/branch_model.riverpod.dart';

class BranchState {
  final bool isLoading;
  final List<BranchModel> branches;
  final String? error;

  const BranchState({
    this.isLoading = false,
    this.branches = const [],
    this.error,
  });

  BranchState copyWith({
    bool? isLoading,
    List<BranchModel>? branches,
    String? error,
  }) {
    return BranchState(
      isLoading: isLoading ?? this.isLoading,
      branches: branches ?? this.branches,
      error: error,
    );
  }
}
