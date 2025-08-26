import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:bonyan/core/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? _selectedRole;
  bool _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const ScreenHeader(title: 'إنشاء حساب جديد'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CustomTextField(
              labelText: 'الاسم الكامل',
              hintText: 'ادخل اسمك الكامل',
              prefixIcon: LucideIcons.user,
            ),
            const SizedBox(height: 20),
            // A more faithful recreation of the phone input from HTML
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('رقم الهاتف', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGray,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        border: Border.all(color: Colors.grey.shade300)
                      ),
                      child: Text('🇾🇪 +967', style: textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary)),
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: '777 777 777',
                          // Adjust borders to merge with the country code selector
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                            borderSide: BorderSide(color: AppTheme.primary, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const CustomTextField(
              labelText: 'كلمة المرور',
              hintText: 'اختر كلمة مرور قوية',
              isPassword: true,
              prefixIcon: LucideIcons.lock,
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
              onPressed: () {
                // TODO: Navigate to OTP screen
                // context.push('/otp');
              },
            ),
          ],
        ),
      ),
    );
  }
}
