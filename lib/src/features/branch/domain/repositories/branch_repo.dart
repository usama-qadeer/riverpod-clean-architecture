import 'package:app_with_riverpod/src/features/branch/data/model/branch_model.riverpod.dart';

abstract class BranchRepo {
  Future<List<BranchModel>> getBranch();
}
