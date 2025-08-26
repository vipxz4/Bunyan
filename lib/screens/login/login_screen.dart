import 'package:bunyan/core/app_theme.dart';
import 'package:bunyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      // Replace all routes with the home screen
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Icon(LucideIcons.building2,
                  size: 64, color: AppTheme.primary),
              const SizedBox(height: 16),
              Text(
                'تسجيل الدخول',
                textAlign: TextAlign.center,
                style: textTheme.displaySmall,
              ),
              const SizedBox(height: 40),
              const CustomTextField(
                labelText: 'رقم الهاتف',
                hintText: '777 777 777',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                labelText: 'كلمة المرور',
                hintText: '********',
                isPassword: true,
                prefixIcon: LucideIcons.lock,
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () {
                    // TODO: Navigate to forgot password screen
                    // context.push('/forgot-password');
                  },
                  child: const Text('نسيت كلمة المرور؟'),
                ),
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                text: 'دخول',
                onPressed: _isLoading ? null : _login,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ليس لديك حساب؟', style: textTheme.bodyMedium),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to register screen
                      // context.push('/register');
                    },
                    child: const Text('إنشاء حساب'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
