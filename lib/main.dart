import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/navigation/app_router.dart';
import 'config/theme/colors.dart';
import 'config/theme/theme.dart';
import 'providers/notifiers/auth_notifier.dart';
import 'providers/notifiers/theme_notifier.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  late Brightness _systemBrightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _systemBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      _systemBrightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appThemeMode = ref.watch(themeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final effectiveBrightness = switch (appThemeMode) {
      AppThemeMode.light => Brightness.light,
      AppThemeMode.dark => Brightness.dark,
      AppThemeMode.system => _systemBrightness,
    };

    AppColors.useBrightness(effectiveBrightness);

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
