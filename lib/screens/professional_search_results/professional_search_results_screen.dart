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
      body: results.when(
        data: (professionals) {
          if (professionals.isEmpty) {
            return const Center(child: Text('لا توجد نتائج مطابقة للبحث.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: professionals.length,
            itemBuilder: (context, index) {
              final professional = professionals[index];
              return ProfessionalCard(
                professional: professional,
                onTap: () {
                  context.push('/home/professional-profile/${professional.id}');
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('حدث خطأ أثناء تحميل النتائج.')),
      ),
    );
  }
}
