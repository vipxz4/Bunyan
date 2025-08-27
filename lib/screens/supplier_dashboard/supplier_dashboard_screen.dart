import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

class SupplierDashboardScreen extends StatelessWidget {
  const SupplierDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ScreenHeader(title: 'لوحة تحكم المورد'),
      body: GridView.count(
        padding: const EdgeInsets.all(16.0),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _DashboardCard(
            icon: LucideIcons.package,
            label: 'منتجاتي',
            value: '150', // Mock data
            onTap: () => context.push('/account/supplier-dashboard/my-products'),
          ),
          _DashboardCard(
            icon: LucideIcons.shoppingCart,
            label: 'الطلبات الجديدة',
            value: '12', // Mock data
            onTap: () => context.push('/account/supplier-dashboard/my-orders'),
          ),
          _DashboardCard(
            icon: LucideIcons.star,
            label: 'التقييمات',
            value: '4.8', // Mock data
            onTap: () {
              // TODO: Navigate to ratings screen
            },
          ),
          _DashboardCard(
            icon: LucideIcons.lineChart,
            label: 'الأرباح',
            value: '1.2M ريال', // Mock data
            onTap: () {
              // TODO: Navigate to earnings screen
            },
          ),
        ],
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
