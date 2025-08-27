import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MyRatingsScreen extends StatelessWidget {
  const MyRatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final mockRatings = [
      {
        'target': 'المهندس أحمد',
        'type': 'تقييم مهني',
        'rating': 4.5,
        'comment': 'عمل ممتاز واحترافية عالية.'
      },
      {
        'target': 'مؤسسة الحمدي للتجارة',
        'type': 'تقييم مورد',
        'rating': 5.0,
        'comment': 'مواد عالية الجودة وسرعة في التوصيل.'
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
                        rating['target'] as String,
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
                    rating['type'] as String,
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
