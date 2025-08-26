import 'dart:async';
import 'package:bunyan/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate after a delay. Using `go` will replace the splash screen
    // in the navigation stack, so the user can't go back to it.
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Icon(LucideIcons.building2, color: Colors.white, size: 128)
                .animate(onPlay: (controller) => controller.repeat())
                .scaleXY(
                  delay: 200.ms,
                  duration: 1500.ms,
                  curve: Curves.easeInOut,
                  end: 1.05,
                )
                .then(delay: 200.ms)
                .scaleXY(
                  duration: 1500.ms,
                  curve: Curves.easeInOut,
                  end: 1 / 1.05,
                ),
            const SizedBox(height: 24),
            Text(
              'بَنّاء',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'بناؤك يبدأ من هنا',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.normal,
                  ),
            ),
            const Spacer(),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms),
    );
  }
}
