import 'package:app_with_riverpod/src/core/network/base_api_service.dart';

class BranchApi {
  final BaseApiService apiService;
  BranchApi(this.apiService);

  Future<dynamic> getBranchJson() {
    return apiService.get('/get-branches');
  }
}
