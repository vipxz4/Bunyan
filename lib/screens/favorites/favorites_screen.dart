// import 'package:bonyan/models/models.dart';
// // Import your new favorites providers file
// import 'package:bonyan/providers/favorites_providers.dart';
// import 'package:bonyan/widgets/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class FavoritesScreen extends StatelessWidget {
//   const FavoritesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(LucideIcons.arrowRight),
//             onPressed: () => context.pop(),
//           ),
//           title: const Text('المفضلة'),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'المهنيون'),
//               Tab(text: 'المنتجات'),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             _FavoriteProfessionalsList(),
//             _FavoriteProductsList(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _FavoriteProfessionalsList extends ConsumerWidget {
//   const _FavoriteProfessionalsList();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Watch the new, efficient provider that fetches full ProfessionalModel objects
//     final favoritesAsync = ref.watch(favoriteProfessionalsProvider);

//     // Use .when() to correctly handle loading, error, and data states
//     return favoritesAsync.when(
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (err, stack) => Center(child: Text('حدث خطأ: $err')),
//       data: (favoriteProfessionals) {
//         if (favoriteProfessionals.isEmpty) {
//           return const Center(child: Text('لم تقم بإضافة أي مهنيين للمفضلة.'));
//         }

//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: favoriteProfessionals.length,
//           itemBuilder: (context, index) {
//             final professional = favoriteProfessionals[index];
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 12.0),
//               child: ProfessionalCard(
//                 professional: professional,
//                 onTap: () =>
//                     context.push('/home/professional-profile/${professional.id}'),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class _FavoriteProductsList extends ConsumerWidget {
//   const _FavoriteProductsList();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Watch the new, efficient provider that fetches full ProductModel objects
//     final favoritesAsync = ref.watch(favoriteProductsProvider);

//     return favoritesAsync.when(
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (err, stack) => Center(child: Text('حدث خطأ: $err')),
//       data: (favoriteProducts) {
//         // Corrected a small typo in the original text
//         if (favoriteProducts.isEmpty) {
//           return const Center(child: Text('لم تقم بإضافة أي منتجات للمفضلة.'));
//         }

//         return GridView.builder(
//           padding: const EdgeInsets.all(16.0),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 0.65,
//           ),
//           itemCount: favoriteProducts.length,
//           itemBuilder: (context, index) {
//             final product = favoriteProducts[index];
//             return ProductCard(
//               product: product,
//               onTap: () {
//                 context.push('/home/product-details/${product.id}');
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }