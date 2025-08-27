import 'package:bonyan/models/product_model.dart';
import 'package:bonyan/providers/data_providers.dart';
import 'package:bonyan/widgets/common/error_display_widget.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

class SupplierDashboardScreen extends ConsumerWidget {
  const SupplierDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDetailsProvider).asData?.value;
    final productsAsyncValue = ref.watch(productsProvider);
    // In a real app, we'd have providers for orders, ratings, etc.
    // For now, we'll derive stats from the products provider.

    return Scaffold(
      appBar: const ScreenHeader(title: 'لوحة تحكم المورد'),
      body: productsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => ErrorDisplayWidget(errorMessage: err.toString()),
        data: (allProducts) {
          final myProducts = user != null
              ? allProducts.where((p) => p.supplierId == user.id).toList()
              : <ProductModel>[];

          return GridView.count(
            padding: const EdgeInsets.all(16.0),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _DashboardCard(
                icon: LucideIcons.package,
                label: 'منتجاتي',
                value: myProducts.length.toString(),
                onTap: () =>
                    context.push('/account/supplier-dashboard/my-products'),
              ),
              _DashboardCard(
                icon: LucideIcons.shoppingCart,
                label: 'الطلبات الجديدة',
                value: '0', // Mock: No orders provider yet
                onTap: () =>
                    context.push('/account/supplier-dashboard/my-orders'),
              ),
              _DashboardCard(
                icon: LucideIcons.star,
                label: 'التقييمات',
                value: 'N/A', // Mock: No ratings provider for suppliers yet
                onTap: () => context.push('/account/my-ratings'),
              ),
              _DashboardCard(
                icon: LucideIcons.lineChart,
                label: 'الأرباح',
                value: 'N/A', // Mock: No earnings provider yet
                onTap: () {
                  // TODO: Navigate to earnings screen
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: textTheme.headlineMedium),
                  Text(label, style: textTheme.titleMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
