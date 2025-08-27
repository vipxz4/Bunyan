import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SpMyBidsScreen extends StatelessWidget {
  const SpMyBidsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final mockBids = [
      {
        'project': 'بناء فيلا - حي النهضة',
        'amount': '15,000,000 ريال',
        'status': 'مقبول'
      },
      {
        'project': 'تشطيب شقة - شارع حده',
        'amount': '3,500,000 ريال',
        'status': 'قيد المراجعة'
      },
      {
        'project': 'أعمال كهرباء - برج السلام',
        'amount': '1,200,000 ريال',
        'status': 'مرفوض'
      },
    ];

    return Scaffold(
      appBar: const ScreenHeader(title: 'عروضي المقدمة'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: mockBids.length,
        itemBuilder: (context, index) {
          final bid = mockBids[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(LucideIcons.gavel),
              title: Text(bid['project'] as String),
              subtitle: Text('المبلغ: ${bid['amount']}'),
              trailing: Text(
                bid['status'] as String,
                style: TextStyle(
                  color: _getStatusColor(bid['status'] as String),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // TODO: Navigate to bid details
              },
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'مقبول':
        return Colors.green;
      case 'قيد المراجعة':
        return Colors.orange;
      case 'مرفوض':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
