import 'package:bonyan/providers/data_providers.dart';
import 'package:bonyan/widgets/cards/product_card.dart';
import 'package:bonyan/widgets/cards/professional_card.dart';
import 'package:bonyan/widgets/common/error_display_widget.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneralSearchResultsScreen extends ConsumerWidget {
  const GeneralSearchResultsScreen({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchAsyncValue = ref.watch(generalSearchProvider(query));

    return Scaffold(
      appBar: ScreenHeader(title: 'نتائج البحث عن "$query"'),
      body: searchAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => ErrorDisplayWidget(errorMessage: err.toString()),
        data: (results) {
          if (results.isEmpty) {
            return const Center(child: Text('لم يتم العثور على نتائج.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              if (result.product != null) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ProductCard(product: result.product!),
                );
              }
              if (result.professional != null) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ProfessionalCard(professional: result.professional!),
                );
              }
              return const SizedBox.shrink(); // Should not happen
            },
          );
        },
      ),
    );
  }
}
