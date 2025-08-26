import 'package:bunyan/providers/providers.dart';
import 'package:bunyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MaterialsSearchResultsScreen extends ConsumerWidget {
  const MaterialsSearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(productsProvider);

    return Scaffold(
      appBar: const ScreenHeader(title: 'نتائج البحث: مواد'),
      body: results.isEmpty
          ? const Center(child: Text('لا توجد منتجات مطابقة للبحث.'))
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final product = results[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    context.push('/home/product-details/${product.id}');
                  },
                );
              },
            ),
    );
  }
}
