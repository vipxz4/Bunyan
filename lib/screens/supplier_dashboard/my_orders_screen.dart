import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final mockOrders = [
      {
        'id': 'ORD-987',
        'customer': 'علي محمد',
        'total': '150,000 ريال',
        'status': 'قيد التجهيز'
      },
      {
        'id': 'ORD-986',
        'customer': 'فاطمة أحمد',
        'total': '32,500 ريال',
        'status': 'في انتظار الدفع'
      },
      {
        'id': 'ORD-985',
        'customer': 'شركة الإعمار',
        'total': '2,500,000 ريال',
        'status': 'تم التوصيل'
      },
    ];

    return Scaffold(
      appBar: const ScreenHeader(title: 'طلباتي'),
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
              subtitle: Text('العميل: ${order['customer']} - الإجمالي: ${order['total']}'),
              trailing: Text(
                order['status'] as String,
                style: TextStyle(
                  color: _getStatusColor(order['status'] as String),
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
      case 'في انتظار الدفع':
        return Colors.blue;
      case 'تم التوصيل':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
