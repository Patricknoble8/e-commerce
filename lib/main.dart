import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'config/navigation/app_router.dart';
import 'config/theme/colors.dart';
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
    final effectiveBrightness = ref.watch(effectiveBrightnessProvider);

    AppColors.useBrightness(effectiveBrightness);

    return MaterialApp(
      title: 'E-Commerce',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const HomeScreen(),
      builder: (context, child) {
        return _SystemAppearanceBridge(child: child ?? const SizedBox.shrink());
      },
      onGenerateRoute: (settings) =>
          AppRouter.onGenerateRoute(settings, ref.read(authProvider)),
    );
  }
}

class _SystemAppearanceBridge extends StatefulWidget {
  const _SystemAppearanceBridge({required this.child});

  final Widget child;

  @override
  State<_SystemAppearanceBridge> createState() =>
      _SystemAppearanceBridgeState();
}

class _SystemAppearanceBridgeState extends State<_SystemAppearanceBridge> {
  Brightness? _lastBrightness;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncSystemAppearance();
  }

  @override
  void didUpdateWidget(covariant _SystemAppearanceBridge oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncSystemAppearance();
  }

  void _syncSystemAppearance() {
    final brightness = Theme.of(context).brightness;
    AppColors.useBrightness(brightness);

    if (_lastBrightness == brightness) return;
    _lastBrightness = brightness;
    SystemChrome.setSystemUIOverlayStyle(
      AppTheme.systemOverlayStyle(brightness),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    AppColors.useBrightness(brightness);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.systemOverlayStyle(brightness),
      child: widget.child,
    );
  }
}
