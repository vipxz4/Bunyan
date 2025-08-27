import 'package:bonyan/models/product_model.dart';
import 'package:bonyan/providers/data_providers.dart';
import 'package:bonyan/widgets/common/error_display_widget.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MyProductsScreen extends ConsumerWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Filter products by current user (supplier)
    final user = ref.watch(userDetailsProvider).asData?.value;
    final productsAsyncValue = ref.watch(productsProvider);

    return Scaffold(
      appBar: const ScreenHeader(title: 'منتجاتي'),
      body: productsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => ErrorDisplayWidget(errorMessage: err.toString()),
        data: (allProducts) {
          // Filter products for the current supplier
          final myProducts = user != null
              ? allProducts.where((p) => p.supplierId == user.id).toList()
              : <ProductModel>[];

          if (myProducts.isEmpty) {
            return const Center(child: Text('لم تقم بإضافة أي منتجات بعد.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: myProducts.length,
            itemBuilder: (context, index) {
              final product = myProducts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.network(product.imageUrl,
                          width: 60, height: 60, fit: BoxFit.cover),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name,
                                style: Theme.of(context).textTheme.titleLarge),
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
          content: const Text('هل أنت متأكد أنك تريد حذف هذا المنتج؟ لا يمكن التراجع عن هذا الإجراء.'),
          actions: <Widget>[
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Consumer(
              builder: (context, ref, child) {
                return FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('حذف'),
                  onPressed: () async {
                    try {
                      await ref.read(productsActionsProvider).deleteProduct(productId);
                      Navigator.of(context).pop(); // Close the dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم حذف المنتج بنجاح.')),
                      );
                    } catch (e) {
                       Navigator.of(context).pop();
                       ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('فشل حذف المنتج: $e')),
                      );
                    }
                  },
                );
              }
            ),
          ],
        );
      },
    );
  }
}
