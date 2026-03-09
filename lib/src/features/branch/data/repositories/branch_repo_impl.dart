import 'package:app_with_riverpod/src/features/branch/data/model/branch_model.riverpod.dart';
import 'package:app_with_riverpod/src/features/branch/data/sources/branch_api.dart';
import 'package:app_with_riverpod/src/features/branch/domain/repositories/branch_repo.dart';

class BranchRepoImpl extends BranchRepo {
  final BranchApi api;
  BranchRepoImpl(this.api);
  @override
  Future<List<BranchModel>> getBranch() async {
    final res = await api.getBranchJson();

    if (res is! Map<String, dynamic>) {
      throw Exception("Invalid response: not a JSON object");
    }

    final data = res['data'];

    if (data is! List) {
      throw Exception("Invalid response: data is not a list");
    }

    return data.map((e) => BranchModel.fromJson(e)).toList();
  }
}
