import 'package:bonyan/core/app_theme.dart';
import 'package:bonyan/models/models.dart';
import 'package:bonyan/providers/favorites_provider.dart';
import 'package:bonyan/providers/providers.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowRight),
            onPressed: () => context.pop(),
          ),
          title: const Text('المفضلة'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'المهنيون'),
              Tab(text: 'المنتجات'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _FavoriteProfessionalsList(),
            _FavoriteProductsList(),
          ],
        ),
      ),
    );
  }
}

class _FavoriteProfessionalsList extends ConsumerWidget {
  const _FavoriteProfessionalsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider).professionalIds;
    final allProfessionals = ref.watch(recommendedProfessionalsProvider);
    final favoriteProfessionals = allProfessionals
        .where((p) => favoriteIds.contains(p.id))
        .toList();

    if (favoriteProfessionals.isEmpty) {
      return const Center(child: Text('لم تقم بإضافة أي مهنيين للمفضلة.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteProfessionals.length,
      itemBuilder: (context, index) {
        final professional = favoriteProfessionals[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ProfessionalCard(
            professional: professional,
            onTap: () =>
                context.push('/home/professional-profile/${professional.id}'),
          ),
        );
      },
    );
  }
}



class _FavoriteProductsList extends ConsumerWidget {
  const _FavoriteProductsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider).productIds;
    final allProducts = ref.watch(productsProvider);
    final favoriteProducts =
        allProducts.where((p) => favoriteIds.contains(p.id)).toList();

    if (favoriteProducts.isEmpty) {
      return const Center(child: Text('لم تقم بإضافة أي منتجات للمفضلة.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: favoriteProducts.length,
      itemBuilder: (context, index) {
        final product = favoriteProducts[index];
        return ProductCard(
          product: product,
          onTap: () {
            context.push('/home/product-details/${product.id}');
          },
        );
      },
    );
  }
}
