import 'package:bonyan/providers/data_providers.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MyProductsScreen extends ConsumerWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return Scaffold(
      appBar: const ScreenHeader(title: 'منتجاتي'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Using an actual image would be better, but for now, an icon is fine.
                  Image.network(product.imageUrl,
                      width: 60, height: 60, fit: BoxFit.cover),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text('السعر: ${product.price.toStringAsFixed(0)} ريال'),
                        Text('المخزون: ${product.stock}'),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.edit, color: Colors.blue),
                    onPressed: () => context.push(
                        '/account/supplier-dashboard/my-products/edit/${product.id}'),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.trash2, color: Colors.red),
                    onPressed: () =>
                        _showDeleteConfirmation(context, ref, product.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.push('/account/supplier-dashboard/my-products/add'),
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, WidgetRef ref, String productId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('هل أنت متأكد أنك تريد حذف هذا المنتج؟'),
          actions: <Widget>[
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('حذف'),
              onPressed: () {
                ref.read(productsProvider.notifier).deleteProduct(productId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
