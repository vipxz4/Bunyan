import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class QuotationRequestsScreen extends StatelessWidget {
  const QuotationRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final mockRequests = [
      {'id': 'RFQ-003', 'title': 'طلب تسعير لأعمال سباكة', 'responses': 5},
      {'id': 'RFQ-002', 'title': 'طلب تسعير لأعمال كهرباء', 'responses': 8},
      {'id': 'RFQ-001', 'title': 'طلب تسعير لأعمال بناء', 'responses': 3},
    ];

    return Scaffold(
      appBar: const ScreenHeader(title: 'طلبات عروض الأسعار'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: mockRequests.length,
        itemBuilder: (context, index) {
          final request = mockRequests[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(LucideIcons.fileText),
              title: Text(request['title'] as String),
              subtitle: Text('رقم الطلب: ${request['id']}'),
              trailing: Chip(
                label: Text('${request['responses']} عروض'),
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              onTap: () {
                // TODO: Navigate to request details
              },
            ),
          );
        },
      ),
    );
  }
}
