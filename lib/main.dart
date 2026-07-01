import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/navigation/app_router.dart';
import 'config/theme/theme.dart';
import 'providers/notifiers/auth_notifier.dart';
import 'providers/notifiers/theme_notifier.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'E-Commerce',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const HomeScreen(),
      onGenerateRoute: (settings) =>
          AppRouter.onGenerateRoute(settings, ref.read(authProvider)),
    );
  }
}
