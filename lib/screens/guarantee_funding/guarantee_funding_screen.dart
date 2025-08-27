import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GuaranteeFundingScreen extends StatelessWidget {
  const GuaranteeFundingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ScreenHeader(title: 'تمويل الضمان'),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'شاشة تمويل الضمان قيد الإنشاء.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
