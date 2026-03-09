import 'package:app_with_riverpod/main_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> runMainApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocalStorage.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'App With Riverpod',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeMode,
        routerConfig: router,
      ),
    );
  }
}
