import 'package:bonyan/providers/providers.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfessionalSearchResultsScreen extends ConsumerWidget {
  const ProfessionalSearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, this would be a filtered list based on a search query.
    // For now, we just display all recommended professionals as results.
    final results = ref.watch(recommendedProfessionalsProvider);

    return Scaffold(
      appBar: const ScreenHeader(title: 'نتائج البحث: مقاولون'),
      body: results.isEmpty
          ? const Center(child: Text('لا توجد نتائج مطابقة للبحث.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final professional = results[index];
                return ProfessionalCard(
                  professional: professional,
                  onTap: () {
                    context.push('/home/professional-profile/${professional.id}');
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
    );
  }
}
