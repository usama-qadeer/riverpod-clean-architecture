// ignore_for_file: use_build_context_synchronously

import 'package:app_with_riverpod/src/core/bootstrap/app_bootstrap_vm.dart';
import 'package:app_with_riverpod/src/core/extensions/extensions.dart';
import 'package:app_with_riverpod/src/core/shared/widgets/custom_elevted_button.dart';
import 'package:app_with_riverpod/src/core/shared/widgets/input.dart';
import 'package:app_with_riverpod/src/core/theme/app_colors.dart';
import 'package:app_with_riverpod/src/features/auth/presentation/providers/login_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final loginNotifier = ref.read(loginProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppInput(controller: emailController, hintText: 'Enter your email'),
        8.vGap,
        AppInput(
          obscureText: true,
          controller: passwordController,
          hintText: 'Enter your password',
        ),

        const SizedBox(height: 16),

        if (loginState.isLoading) const CircularProgressIndicator(),

        if (loginState.error != null)
          Text(
            loginState.error!,
            style: const TextStyle(color: AppColors.dangerRed),
          ),

        if (!loginState.isLoading)
          CustomElevatedButton(
            text: 'Login',
            onPressed: () async {
              await loginNotifier.login(
                emailController.text.trim(),
                passwordController.text.trim(),
                onLoggedIn: () {
                  ref.read(appBootstrapProvider.notifier).reset();
                },
              );

              if (loginState.user != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login Successful')),
                );
              } else if (loginState.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.dangerRed,
                    content: Text(
                      loginState.error!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }
            },
          ),
      ],
    );
  }
}
