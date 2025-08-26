import 'package:bonyan/core/app_theme.dart';
import 'package:bonyan/providers/providers.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutSummaryScreen extends ConsumerWidget {
  const CheckoutSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const ScreenHeader(title: 'مراجعة وتأكيد الطلب'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionCard(
              context,
              title: 'المنتجات',
              child: _buildProductsList(ref),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              context,
              title: 'ملخص الدفع',
              child: _buildPaymentSummary(context, ref),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              context,
              title: 'تعليمات الاستلام',
              child: const Text(
                'سيتم إشعار المورد لتجهيز الطلب بعد تأمين المبلغ. الاستلام من مقر المورد في صنعاء - شارع تعز. يجب تنسيق وقت الاستلام مع المورد مباشرة عبر المحادثات.',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: PrimaryButton(
          text: 'تأكيد والانتقال لتمويل الضمان',
          onPressed: () {
            // TODO: Navigate to guarantee funding screen
          },
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context,
      {required String title, required Widget child}) {
    return Card(
      elevation: 0,
      color: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList(WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: item.product.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name,
                      style: Theme.of(context).textTheme.titleLarge),
                  Text('الكمية: ${item.quantity}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Text('${(item.totalPrice).toStringAsFixed(0)} ريال',
                style: Theme.of(context).textTheme.titleLarge),
          ],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
  }

  Widget _buildPaymentSummary(BuildContext context, WidgetRef ref) {
    final subtotal = ref.watch(cartTotalProvider);
    const double fees = 500; // Mock fees
    final total = subtotal + fees;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('المجموع الفرعي', style: textTheme.bodyLarge),
            Text('${subtotal.toStringAsFixed(0)} ريال',
                style: textTheme.bodyLarge),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('رسوم خدمة الضمان', style: textTheme.bodyLarge),
            Text('${fees.toStringAsFixed(0)} ريال', style: textTheme.bodyLarge),
          ],
        ),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('الإجمالي', style: textTheme.headlineSmall),
            Text('${total.toStringAsFixed(0)} ريال',
                style: textTheme.headlineSmall?.copyWith(color: AppTheme.primary)),
          ],
        ),
      ],
    );
  }
}
