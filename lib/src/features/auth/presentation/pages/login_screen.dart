import 'package:app_with_riverpod/main_exports.dart';
import 'package:app_with_riverpod/src/core/extensions/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/login_form.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: [
          IconButton(
            onPressed: () {
              final themeNotifier = ref.read(themeProvider.notifier);

              if (ref.read(themeProvider) == ThemeMode.dark) {
                themeNotifier.setMode(ThemeMode.light);
              } else {
                themeNotifier.setMode(ThemeMode.dark);
              }
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(child: LoginForm()).px16,
    );
  }
}
