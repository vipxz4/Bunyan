import 'package:bonyan/core/app_theme.dart';
import 'package:bonyan/services/auth_service.dart';
import 'package:bonyan/utils/error_handler.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() => _isLoading = true);
      try {
        await ref.read(authServiceProvider).signInWithEmailAndPassword(
              _emailController.text,
              _passwordController.text,
            );
        // On success, the auth state listener in the router should handle navigation.
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          final errorMessage = handleAuthException(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
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
                CustomTextField(
                  controller: _emailController,
                  labelText: 'البريد الإلكتروني',
                  hintText: 'example@email.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: LucideIcons.mail,
                  validator: (value) =>
                      value!.isEmpty ? 'الرجاء إدخال البريد الإلكتروني' : null,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'كلمة المرور',
                  hintText: '********',
                  isPassword: true,
                  prefixIcon: LucideIcons.lock,
                  validator: (value) =>
                      value!.isEmpty ? 'الرجاء إدخال كلمة المرور' : null,
                ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () => context.push('/forgot-password'),
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
                    onPressed: () => context.push('/register'),
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
