import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SpRatingsScreen extends StatelessWidget {
  const SpRatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final mockRatings = [
      {
        'customer': 'علي محمد',
        'project': 'بناء فيلا - حي النهضة',
        'rating': 5.0,
        'comment': 'التزام بالوقت وجودة في العمل. أنصح به بشدة.'
      },
      {
        'customer': 'فاطمة أحمد',
        'project': 'تشطيب شقة',
        'rating': 4.0,
        'comment': 'جيد جداً، كان هناك تأخير بسيط في التسليم فقط.'
      },
    ];

    return Scaffold(
      appBar: const ScreenHeader(title: 'تقييماتي'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: mockRatings.length,
        itemBuilder: (context, index) {
          final rating = mockRatings[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        rating['customer'] as String,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Row(
                        children: [
                          const Icon(LucideIcons.star,
                              color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            (rating['rating'] as double).toStringAsFixed(1),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'المشروع: ${rating['project']}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Divider(height: 16),
                  Text(
                    rating['comment'] as String,
                    style: Theme.of(context).textTheme.bodyMedium,
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
