import 'package:bonyan/core/app_theme.dart';
import 'package:bonyan/models/models.dart';
import 'package:bonyan/providers/providers.dart';
import 'package:bonyan/widgets/common/error_display_widget.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsyncValue = ref.watch(cartProvider);

    return Scaffold(
      appBar: const ScreenHeader(title: 'سلة التسوق'),
      body: cartAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => ErrorDisplayWidget(errorMessage: err.toString()),
        data: (cartItems) {
          if (cartItems.isEmpty) {
            return _buildEmptyState(context);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              return _CartItemCard(item: cartItems[index]);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          );
        },
      ),
      bottomNavigationBar:
          cartAsyncValue.asData?.value.isEmpty ?? true ? null : const _SummaryBar(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.shoppingCart,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('سلة التسوق فارغة',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('أضف بعض المنتجات لتبدأ.'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/home/materials-search'),
            child: const Text('متابعة التسوق'),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends ConsumerWidget {
  const _CartItemCard({required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: item.product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name, style: textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text('${item.product.price.toStringAsFixed(0)} ريال',
                      style: textTheme.bodyLarge
                          ?.copyWith(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildQuantityButton(context, ref, LucideIcons.minus, () {
                        ref.read(cartActionsProvider).updateQuantity(
                            item.product.id, item.quantity - 1);
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child:
                            Text('${item.quantity}', style: textTheme.titleLarge),
                      ),
                      _buildQuantityButton(context, ref, LucideIcons.plus, () {
                        ref.read(cartActionsProvider).updateQuantity(
                            item.product.id, item.quantity + 1);
                      }),
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.trash2, color: AppTheme.red),
              onPressed: () =>
                  ref.read(cartActionsProvider).removeItem(item.product.id),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(BuildContext context, WidgetRef ref, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      height: 32,
      width: 32,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _SummaryBar extends ConsumerWidget {
  const _SummaryBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(cartTotalProvider);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('المجموع الكلي',
                  style: Theme.of(context).textTheme.headlineSmall),
              Text('${total.toStringAsFixed(0)} ريال',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.primary)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.go('/home/materials-search'),
                  child: const Text('متابعة التسوق'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(
                  text: 'إرسال الطلبات',
                  onPressed: () {
                    context.push('/home/checkout-summary');
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
