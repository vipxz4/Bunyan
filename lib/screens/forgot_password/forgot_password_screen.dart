import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ScreenHeader(title: 'نسيت كلمة المرور'),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'سيتم إرسال رمز التحقق إلى رقم هاتفك لإعادة تعيين كلمة المرور.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'رقم الهاتف',
                hintText: '777 777 777',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              PrimaryButton(
                text: 'إرسال الرمز',
                onPressed: null, // TODO: Implement send OTP
              ),
            ],
          ),
        ),
      ),
    );
  }
}
