import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This feature is not yet connected to a real data source.
    // Displaying an empty state is more honest than showing mock data.
    final orders = [];

    return Scaffold(
      appBar: const ScreenHeader(title: 'طلباتي'),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.shoppingCart, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد طلبات حالياً.',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'سيتم عرض الطلبات الجديدة هنا عند توفرها.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                // This code will not be reached until a real data source is connected.
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(LucideIcons.receipt),
                    title: Text('طلب رقم #${order['id']}'),
                    subtitle: Text(
                        'العميل: ${order['customer']} - الإجمالي: ${order['total']}'),
                    trailing: Text(
                      order['status'] as String,
                      style: TextStyle(
                        color: _getStatusColor(order['status'] as String),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // TODO: Navigate to order details once the feature is implemented
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
