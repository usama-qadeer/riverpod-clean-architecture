import 'package:app_with_riverpod/src/core/bootstrap/app_bootstrap_vm.dart';
import 'package:app_with_riverpod/src/features/auth/presentation/providers/login_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _loadTriggered = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeStartBootstrap();
    });
  }

  void _maybeStartBootstrap() {
    if (_loadTriggered) return;

    final auth = ref.read(authProvider);
    final bootstrap = ref.read(appBootstrapProvider);

    if (!auth.checking &&
        auth.isLoggedIn &&
        !bootstrap.ready &&
        !bootstrap.loading) {
      _loadTriggered = true;
      ref.read(appBootstrapProvider.notifier).load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // 🔥 Listen to state
    final auth = ref.watch(authProvider);
    final bootstrap = ref.watch(appBootstrapProvider);

    // Try bootstrap again when auth changes
    if (!auth.checking &&
        auth.isLoggedIn &&
        !bootstrap.ready &&
        !bootstrap.loading &&
        !_loadTriggered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _maybeStartBootstrap();
      });
    }

    String subtitle;

    if (auth.checking) {
      subtitle = "Checking session…";
    } else if (!auth.isLoggedIn) {
      subtitle = "Redirecting to login…";
    } else if (bootstrap.error != null) {
      subtitle = "Failed to load startup data";
    } else {
      subtitle = "Preparing your workspace…";
    }

    return Scaffold(
      backgroundColor: cs.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.storefront, size: 60, color: cs.primary),
            const SizedBox(height: 16),
            Text("Code Art", style: tt.titleLarge),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),

            const SizedBox(height: 20),

            if (bootstrap.loading) const CircularProgressIndicator(),

            if (bootstrap.error != null) ...[
              const SizedBox(height: 12),
              Text(
                bootstrap.error!,
                style: TextStyle(color: cs.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  ref.read(appBootstrapProvider.notifier).reset();
                  _loadTriggered = false;
                  _maybeStartBootstrap();
                },
                child: const Text("Retry"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
