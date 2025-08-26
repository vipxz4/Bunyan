import 'package:bonyan/providers/providers.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfessionalSearchScreen extends ConsumerWidget {
  const ProfessionalSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topRated = ref.watch(recommendedProfessionalsProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const ScreenHeader(title: 'البحث عن مهنيين'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'بحث بالاسم, مهنة...',
                  prefixIcon: Icon(LucideIcons.search),
                ),
                onSubmitted: (value) => context.push('/home/professional-search-results'),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('التصفح حسب الفئات', style: textTheme.headlineSmall),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _CategoryCard(icon: LucideIcons.hardHat, label: 'مقاولون', onTap: () => context.push('/home/professional-search-results')),
                  _CategoryCard(icon: LucideIcons.wrench, label: 'سباكون', onTap: () => context.push('/home/professional-search-results')),
                  _CategoryCard(icon: LucideIcons.plugZap, label: 'كهربائيون', onTap: () => context.push('/home/professional-search-results')),
                  _CategoryCard(icon: LucideIcons.hardHat, label: 'نقاشون', onTap: () => context.push('/home/professional-search-results')),
                  _CategoryCard(icon: LucideIcons.hardHat, label: 'مهندسون', onTap: () => context.push('/home/professional-search-results')),
                  _CategoryCard(icon: LucideIcons.layoutGrid, label: 'أخرى', onTap: () => context.push('/home/professional-search-results')),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('أعلى تقييماً', style: textTheme.headlineSmall),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: topRated.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => ProfessionalCard(
                professional: topRated[index],
                onTap: () => context.push('/home/professional-profile/${topRated[index].id}'),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('أو قم بإنشاء طلب عرض سعر عام'),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
