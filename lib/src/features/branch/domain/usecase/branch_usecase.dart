import 'package:app_with_riverpod/src/features/branch/data/model/branch_model.riverpod.dart';
import 'package:app_with_riverpod/src/features/branch/domain/repositories/branch_repo.dart';

class BranchUsecase {
  final BranchRepo branchRepo;
  BranchUsecase(this.branchRepo);

  Future<List<BranchModel>> call() async {
    return await branchRepo.getBranch();
  }
}
