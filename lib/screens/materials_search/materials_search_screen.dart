import 'package:badges/badges.dart' as badges;
import 'package:bonyan/providers/providers.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MaterialsSearchScreen extends ConsumerWidget {
  const MaterialsSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredProducts = ref.watch(productsProvider);
    final cartItemCount = ref.watch(cartItemCountProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: ScreenHeader(
        title: 'البحث عن مواد بناء',
        actions: [
          IconButton(
            onPressed: () => context.push('/home/cart'),
            icon: badges.Badge(
              showBadge: cartItemCount > 0,
              badgeContent: Text('$cartItemCount',
                  style: const TextStyle(color: Colors.white, fontSize: 10)),
              position: badges.BadgePosition.topEnd(top: -12, end: -12),
              child: const Icon(LucideIcons.shoppingCart),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'إسمنت, طوب, حديد تسليح...',
                  prefixIcon: Icon(LucideIcons.search),
                ),
                onSubmitted: (value) =>
                    context.push('/home/materials-search-results'),
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
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _CategoryCard(
                      icon: LucideIcons.gem,
                      label: 'إسمنت ورمل',
                      onTap: () =>
                          context.push('/home/materials-search-results')),
                  _CategoryCard(
                      icon: LucideIcons.truck,
                      label: 'طوب وبلك',
                      onTap: () =>
                          context.push('/home/materials-search-results')),
                  _CategoryCard(
                      icon: LucideIcons.blinds,
                      label: 'أخشاب',
                      onTap: () =>
                          context.push('/home/materials-search-results')),
                  _CategoryCard(
                      icon: LucideIcons.hammer,
                      label: 'حديد',
                      onTap: () =>
                          context.push('/home/materials-search-results')),
                  _CategoryCard(
                      icon: LucideIcons.paintBucket,
                      label: 'دهانات',
                      onTap: () =>
                          context.push('/home/materials-search-results')),
                  _CategoryCard(
                      icon: LucideIcons.pill,
                      label: 'أدوات',
                      onTap: () =>
                          context.push('/home/materials-search-results')),
                ],
              ),
            ),
            SectionHeader(
              title: 'عروض مميزة',
              onViewAll: () {},
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            ),
            HorizontalCardCarousel(
              height: 320,
              itemCount: featuredProducts.length,
              itemBuilder: (context, index) {
                final product = featuredProducts[index];
                return SizedBox(
                  width: 200,
                  child: ProductCard(
                    product: product,
                    onTap: () => context.push('/home/product-details/${product.id}'),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('طلب عرض سعر عام للمواد'),
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
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)
            ),
          ],
        ),
      ),
    );
  }
}
