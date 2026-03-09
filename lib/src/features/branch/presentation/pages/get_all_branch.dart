import 'package:app_with_riverpod/main_exports.dart';
import 'package:app_with_riverpod/src/core/extensions/extensions.dart';
import 'package:app_with_riverpod/src/features/branch/presentation/providers/branch_providers.riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetAllBranchView extends ConsumerWidget {
  const GetAllBranchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          AppLocalStorage.clearAll();
        },
        child: const Icon(Icons.logout_outlined),
      ),
      backgroundColor: context.colors.outline,
      appBar: AppBar(title: const Text('Get All Branch')),
      body: Column(
        children: [
          Consumer(
            builder: (_, ref, _) {
              final branchs = ref.watch(branchesProvider);

              if (branchs.isLoading) {
                return Center(
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                );
              } else if (branchs.error != null) {
                return Column(
                  children: [
                    Text(branchs.error.toString()),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(branchesProvider.notifier).getBranchData();
                      },
                      child: Text("Retry"),
                    ),
                  ],
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: branchs.branches.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = branchs.branches[index];
                  return Text(data.name);
                },
              );
            },
          ),
        ],
      ).p16,
    );
  }
}
