import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bonyan/core/app_router.dart';
import 'package:bonyan/core/app_theme.dart';

void main() {
  // Ensure that widget binding is initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // ProviderScope is what makes Riverpod work.
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We use MaterialApp.router to integrate with go_router.
    return MaterialApp.router(
      title: 'بنيان',
      theme: AppTheme.lightTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,

      // --- Localization Settings ---
      // This ensures the app's UI is right-to-left for Arabic.
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''), // Arabic, no country code
      ],
      locale: const Locale('ar', ''),
    );
  }
}
