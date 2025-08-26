import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    // Request focus on the first field when the screen loads.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onInputChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 45,
      height: 60,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 1,
        style: Theme.of(context).textTheme.headlineMedium,
        decoration: const InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) => _onInputChanged(value, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const ScreenHeader(title: 'التحقق من رقم الهاتف'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'لقد أرسلنا رمز تحقق مكون من 6 أرقام إلى الرقم ******',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 30),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => _buildOtpBox(index)),
              ),
            ),
            const SizedBox(height: 30),
            PrimaryButton(
              text: 'تحقق',
              onPressed: () {
                // TODO: Handle OTP verification logic
                // context.go('/home'); or context.go('/reset-password');
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('لم تستلم الرمز؟', style: textTheme.bodyMedium),
                TextButton(
                  onPressed: () {
                    // TODO: Handle resend OTP logic
                  },
                  child: const Text('إعادة إرسال'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
