import 'package:bonyan/core/app_theme.dart';
import 'package:bonyan/models/models.dart';
import 'package:bonyan/providers/favorites_provider.dart';
import 'package:bonyan/providers/providers.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  const ProductDetailsScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailsProvider(widget.id));

    return productAsync.when(
      data: (product) {
        if (product == null) {
          return const Scaffold(body: Center(child: Text('المنتج غير موجود.')));
        }
        final textTheme = Theme.of(context).textTheme;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                actions: [
                  Consumer(builder: (context, ref, _) {
                    final isFavorite = ref.watch(favoritesProvider
                        .select((favs) => favs.productIds.contains(widget.id)));
                    return IconButton(
                      icon: Icon(
                          isFavorite ? LucideIcons.heart : LucideIcons.heart,
                          color: isFavorite ? AppTheme.red : Colors.white),
                      onPressed: () => ref
                          .read(favoritesProvider.notifier)
                          .toggleProductFavorite(widget.id),
                      style:
                          IconButton.styleFrom(backgroundColor: Colors.black26),
                    );
                  })
                ],
                leading: IconButton(
                  icon: const Icon(LucideIcons.arrowRight, color: Colors.white),
                  onPressed: () => context.pop(),
                  style: IconButton.styleFrom(backgroundColor: Colors.black26),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: textTheme.displaySmall),
                      const SizedBox(height: 8),
                      Text(
                        '${product.price.toStringAsFixed(0)} ريال',
                        style: textTheme.displayMedium
                            ?.copyWith(color: AppTheme.primary),
                      ),
                      Text('/ ${product.unit}', style: textTheme.headlineSmall),
                      const SizedBox(height: 24),
                      _buildSupplierInfo(context, product, textTheme),
                      const SizedBox(height: 24),
                      Text('الوصف', style: textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text(product.description, style: textTheme.bodyLarge),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: _buildAddToCartBar(context, product),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }

  Widget _buildSupplierInfo(
      BuildContext context, ProductModel product, TextTheme textTheme) {
    return InkWell(
      onTap: () => context.push('/home/supplier-profile/${product.supplierId}'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.lightGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Placeholder for supplier image
            const CircleAvatar(
              radius: 25,
              child: Icon(LucideIcons.store),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.supplierName, style: textTheme.titleLarge),
                  Text('مورد معتمد', style: textTheme.bodyMedium),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronLeft, color: AppTheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToCartBar(BuildContext context, ProductModel product) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.lightGray),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => setState(() {
                    if (_quantity > 1) _quantity--;
                  }),
                  icon: const Icon(LucideIcons.minus),
                ),
                Text('$_quantity',
                    style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  onPressed: () => setState(() {
                    _quantity++;
                  }),
                  icon: const Icon(LucideIcons.plus),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: PrimaryButton(
              text: 'أضف للسلة',
              icon: LucideIcons.shoppingCart,
              onPressed: () {
                ref.read(cartProvider.notifier).addItem(product, _quantity);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تمت إضافة ${product.name} إلى السلة'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
