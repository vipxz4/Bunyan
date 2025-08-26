import 'package:bunyan/core/app_theme.dart';
import 'package:bunyan/models/models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  bool _isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _isLastPage = index == onboardingSlidesData.length - 1;
              });
            },
            itemCount: onboardingSlidesData.length,
            itemBuilder: (context, index) {
              return OnboardingPage(slide: onboardingSlidesData[index]);
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: _buildNavigationControls(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavigationControls() {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 80,
          child: _isLastPage
              ? const SizedBox.shrink()
              : TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    'تخطي',
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
        SmoothPageIndicator(
          controller: _pageController,
          count: onboardingSlidesData.length,
          effect: const ExpandingDotsEffect(
            dotColor: AppTheme.lightGray,
            activeDotColor: AppTheme.primary,
            dotHeight: 10,
            dotWidth: 10,
            expansionFactor: 3,
          ),
        ),
        SizedBox(
          width: 80,
          child: TextButton(
            onPressed: () {
              if (_isLastPage) {
                context.go('/login');
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Text(
              _isLastPage ? 'ابدأ الآن' : 'التالي',
              style: textTheme.bodyLarge?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
