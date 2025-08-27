import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ServiceProviderDashboardScreen extends StatelessWidget {
  const ServiceProviderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ScreenHeader(title: 'لوحة تحكم مقدم الخدمة'),
      body: GridView.count(
        padding: const EdgeInsets.all(16.0),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _DashboardCard(
            icon: LucideIcons.briefcase,
            label: 'مشاريعي الحالية',
            value: '3', // Mock data
            onTap: () =>
                context.push('/account/service-provider-dashboard/my-projects'),
          ),
          _DashboardCard(
            icon: LucideIcons.gavel,
            label: 'عروضي المقدمة',
            value: '8', // Mock data
            onTap: () =>
                context.push('/account/service-provider-dashboard/my-bids'),
          ),
          _DashboardCard(
            icon: LucideIcons.star,
            label: 'تقييماتي',
            value: '4.9', // Mock data
            onTap: () =>
                context.push('/account/service-provider-dashboard/my-ratings'),
          ),
          _DashboardCard(
            icon: LucideIcons.lineChart,
            label: 'الأرباح',
            value: '2.5M ريال', // Mock data
            onTap: () =>
                context.push('/account/service-provider-dashboard/my-earnings'),
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
