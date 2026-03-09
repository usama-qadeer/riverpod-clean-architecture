import 'package:app_with_riverpod/src/features/branch/presentation/pages/get_all_branch.dart';

import 'routes_export.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  final bootstrap = ref.watch(appBootstrapProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,

    redirect: (context, state) {
      final loc = state.matchedLocation;

      final isSplash = loc == AppRoutes.splash;
      final isLogin = loc == AppRoutes.login;

      /// 1️⃣ If session still checking → stay on splash
      if (auth.checking) {
        return isSplash ? null : AppRoutes.splash;
      }

      /// 2️⃣ If NOT logged in → go to login
      if (!auth.isLoggedIn) {
        if (isLogin) return null;
        return AppRoutes.login;
      }

      /// 3️⃣ If logged in but bootstrap not ready → stay on splash
      if (!bootstrap.ready) {
        return isSplash ? null : AppRoutes.splash;
      }

      /// 4️⃣ If logged in & bootstrap ready → go to branches
      if (isSplash || isLogin) {
        return AppRoutes.branches;
      }

      /// 5️⃣ Role guard
      if (loc == AppRoutes.admin && auth.role != UserRole.admin) {
        return AppRoutes.branches;
      }

      return null;
    },

    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.branches,
        builder: (_, _) => const GetAllBranchView(),
      ),

      GoRoute(
        path: AppRoutes.admin,
        builder: (_, _) =>
            const Scaffold(body: Center(child: Text("Admin Panel"))),
      ),
    ],
  );
});
