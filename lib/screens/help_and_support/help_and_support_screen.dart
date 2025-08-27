import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ScreenHeader(title: 'المساعدة والدعم'),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(context, 'الأسئلة الشائعة'),
          const ExpansionTile(
            leading: Icon(LucideIcons.helpCircle),
            title: Text('كيف يعمل الدفع بالضمان؟'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    'الدفع بالضمان هو خدمة لحماية أموالك. يبقى المبلغ لدينا حتى يؤكد الطرفان إتمام الخدمة بنجاح، ثم يتم تحويل المبلغ.'),
              ),
            ],
          ),
          const ExpansionTile(
            leading: Icon(LucideIcons.helpCircle),
            title: Text('كيف يمكنني إلغاء طلب؟'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    'لإلغاء طلب، اذهب إلى صفحة الطلب واضغط على زر الإلغاء. يرجى ملاحظة أنه قد يتم تطبيق بعض الشروط بناءً على حالة الطلب.'),
              ),
            ],
          ),
          const Divider(height: 32),
          _buildSectionTitle(context, 'تواصل معنا'),
          const ListTile(
            leading: Icon(LucideIcons.phone),
            title: Text('اتصل بنا'),
            subtitle: Text('+967 777 777 777'),
          ),
          const ListTile(
            leading: Icon(LucideIcons.mail),
            title: Text('البريد الإلكتروني'),
            subtitle: Text('support@bonyan.app'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
