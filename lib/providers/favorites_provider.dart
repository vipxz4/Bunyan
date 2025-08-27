import 'package:bonyan/providers/data_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider simply exposes the list of favorite professional IDs from the current user.
final favoriteProfessionalsProvider = Provider<List<String>>((ref) {
  return ref.watch(userDetailsProvider).asData?.value?.favoriteProfessionalIds ??
      [];
});

// This provider exposes the list of favorite product IDs from the current user.
final favoriteProductsProvider = Provider<List<String>>((ref) {
  return ref.watch(userDetailsProvider).asData?.value?.favoriteProductIds ?? [];
});
