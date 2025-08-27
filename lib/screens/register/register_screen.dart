import 'package:bonyan/services/auth_service.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:bonyan/core/app_theme.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  String? _selectedRole;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() => _isLoading = true);
      try {
        await ref.read(authServiceProvider).signUpWithEmailAndPassword(
              _emailController.text,
              _passwordController.text,
            );
        // On success, the auth state listener in the router should handle navigation.
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
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
      appBar: const ScreenHeader(title: 'إنشاء حساب جديد'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CustomTextField(
                labelText: 'الاسم الكامل',
                hintText: 'ادخل اسمك الكامل',
                prefixIcon: LucideIcons.user,
              ),
              const SizedBox(height: 20),
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
                hintText: 'اختر كلمة مرور قوية',
                isPassword: true,
                prefixIcon: LucideIcons.lock,
                validator: (value) =>
                    value!.length < 6 ? 'كلمة المرور قصيرة جداً' : null,
              ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              hint: const Text('اختر دورك...'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRole = newValue;
                });
              },
              items: <String>['عميل', 'مهني/مقاول', 'مورد']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'ما هو دورك الأساسي؟',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      _termsAccepted = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: textTheme.bodyMedium,
                      children: [
                        const TextSpan(text: 'أوافق على '),
                        TextSpan(
                          text: 'الشروط والأحكام',
                          style: const TextStyle(color: AppTheme.primary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: Navigate to terms screen
                              // context.push('/terms');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'إنشاء حساب',
              onPressed: _register,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('لديك حساب بالفعل؟', style: textTheme.bodyMedium),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('تسجيل الدخول'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
