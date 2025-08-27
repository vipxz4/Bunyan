import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SpMyProjectsScreen extends StatelessWidget {
  const SpMyProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final mockProjects = [
      {
        'name': 'بناء فيلا - حي النهضة',
        'customer': 'علي محمد',
        'status': 'قيد التنفيذ',
        'progress': 0.45
      },
      {
        'name': 'تشطيب شقة',
        'customer': 'فاطمة أحمد',
        'status': 'مكتمل',
        'progress': 1.0
      },
    ];

    return Scaffold(
      appBar: const ScreenHeader(title: 'مشاريعي'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: mockProjects.length,
        itemBuilder: (context, index) {
          final project = mockProjects[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project['name'] as String,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text('العميل: ${project['customer']}'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('الحالة: ${project['status']}'),
                      Text('${((project['progress'] as double) * 100).toInt()}%'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: project['progress'] as double,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
