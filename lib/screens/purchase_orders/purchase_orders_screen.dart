import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PurchaseOrdersScreen extends StatelessWidget {
  const PurchaseOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final mockOrders = [
      {'id': '1122', 'supplier': 'مؤسسة الحمدي للتجارة', 'status': 'قيد التجهيز'},
      {'id': '1121', 'supplier': 'شركة إخوان ثابت', 'status': 'تم التوصيل'},
      {'id': '1120', 'supplier': 'مصنع الوحدة للأسمنت', 'status': 'ملغي'},
    ];

    return Scaffold(
      appBar: const ScreenHeader(title: 'طلبات الشراء'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: mockOrders.length,
        itemBuilder: (context, index) {
          final order = mockOrders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(LucideIcons.receipt),
              title: Text('طلب رقم #${order['id']}'),
              subtitle: Text('المورد: ${order['supplier']}'),
              trailing: Text(
                order['status']!,
                style: TextStyle(
                  color: _getStatusColor(order['status']!),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // TODO: Navigate to order details
              },
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'قيد التجهيز':
        return Colors.orange;
      case 'تم التوصيل':
        return Colors.green;
      case 'ملغي':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
