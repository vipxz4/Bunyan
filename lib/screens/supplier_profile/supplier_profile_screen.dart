import 'package:bonyan/core/app_theme.dart';
import 'package:bonyan/models/models.dart';
import 'package:bonyan/providers/providers.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SupplierProfileScreen extends ConsumerWidget {
  const SupplierProfileScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplierAsync = ref.watch(supplierDetailsProvider(id));
    final allProductsAsync = ref.watch(productsProvider);
    final supplierProducts = allProductsAsync.maybeWhen(
      data: (products) => products.where((p) => p.supplierId == id).toList().cast<ProductModel>(),
      orElse: () => <ProductModel>[],
    );

    return supplierAsync.when(
          data: (supplier) {
            if (supplier == null) {
              return const Scaffold(
                body: Center(child: Text('المورد غير موجود.')),
              );
            }
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  _buildHeader(context, supplier),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -40),
                          child: _buildInfoSection(context, supplier),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDeliveryPolicySection(context, supplier),
                              const SizedBox(height: 24),
                              _buildProductsSection(context, supplierProducts),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: _buildActionButtons(context),
            );
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (err, stack) => Scaffold(
            body: Center(child: Text('حدث خطأ: $err')),
          ),
        ) ??
        const Scaffold(
          body: Center(child: Text('لا توجد بيانات متاحة.')),
        );
  }

  SliverAppBar _buildHeader(BuildContext context, SupplierModel supplier) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      leading: IconButton(
        icon: const Icon(LucideIcons.arrowRight, color: Colors.white),
        onPressed: () => context.pop(),
        style: IconButton.styleFrom(backgroundColor: Colors.black26),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(color: AppTheme.primary),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, SupplierModel supplier) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppTheme.surface,
          child: CircleAvatar(
            radius: 46,
            backgroundImage: supplier.avatarUrl != null
                ? CachedNetworkImageProvider(supplier.avatarUrl!)
                : null,
            child: supplier.avatarUrl == null
                ? const Icon(LucideIcons.store, size: 40)
                : null,
          ),
        ),
        const SizedBox(height: 12),
        Text(supplier.name,
            style: textTheme.displaySmall, textAlign: TextAlign.center),
        Text(supplier.specialty, style: textTheme.bodyLarge),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            Text('${supplier.rating} (${supplier.reviewCount} تقييم)',
                style: textTheme.bodyLarge),
          ],
        ),
      ],
    );
  }

  Widget _buildDeliveryPolicySection(
      BuildContext context, SupplierModel supplier) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('سياسة التوصيل', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(supplier.deliveryPolicy, style: textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildProductsSection(
      BuildContext context, List<ProductModel> products) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('جميع المنتجات', style: textTheme.headlineSmall),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.65,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => context.push('/home/product-details/${product.id}'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: OutlinedButton(
              child: const Text('تواصل'),
              onPressed: () => context.push('/home/chat/chat_supplier_1'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('محمد'),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              child: const Text('طلب عرض سعر'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
