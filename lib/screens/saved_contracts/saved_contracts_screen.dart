import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SavedContractsScreen extends StatelessWidget {
  const SavedContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final mockContracts = [
      {'id': 'CON-051', 'title': 'عقد بناء فيلا - حي النهضة', 'party': 'شركة البناء الحديث'},
      {'id': 'CON-048', 'title': 'عقد توريد مواد - مشروع المستشفى', 'party': 'مؤسسة الحمدي للتجارة'},
    ];

    return Scaffold(
      appBar: const ScreenHeader(title: 'العقود المحفوظة'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: mockContracts.length,
        itemBuilder: (context, index) {
          final contract = mockContracts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(LucideIcons.fileSignature),
              title: Text(contract['title'] as String),
              subtitle: Text('الطرف الثاني: ${contract['party']}'),
              trailing: const Icon(LucideIcons.chevronLeft),
              onTap: () {
                // TODO: Navigate to contract details
              },
            ),
          );
        },
      ),
    );
  }
}
