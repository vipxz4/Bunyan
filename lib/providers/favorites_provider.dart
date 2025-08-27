import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

@immutable
class FavoritesState {
  final Set<String> professionalIds;
  final Set<String> productIds;

  const FavoritesState({
    this.professionalIds = const {},
    this.productIds = const {},
  });

  FavoritesState copyWith({
    Set<String>? professionalIds,
    Set<String>? productIds,
  }) {
    return FavoritesState(
      professionalIds: professionalIds ?? this.professionalIds,
      productIds: productIds ?? this.productIds,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FavoritesState &&
        setEquals(other.professionalIds, professionalIds) &&
        setEquals(other.productIds, productIds);
  }

  @override
  int get hashCode => professionalIds.hashCode ^ productIds.hashCode;
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  FavoritesNotifier() : super(const FavoritesState());

  void toggleProfessionalFavorite(String id) {
    final currentFavorites = state.professionalIds;
    if (currentFavorites.contains(id)) {
      state = state.copyWith(professionalIds: {...currentFavorites}..remove(id));
    } else {
      state = state.copyWith(professionalIds: {...currentFavorites, id});
    }
  }

  void toggleProductFavorite(String id) {
    final currentFavorites = state.productIds;
    if (currentFavorites.contains(id)) {
      state = state.copyWith(productIds: {...currentFavorites}..remove(id));
    } else {
      state = state.copyWith(productIds: {...currentFavorites, id});
    }
  }

  bool isProfessionalFavorite(String id) {
    return state.professionalIds.contains(id);
  }

  bool isProductFavorite(String id) {
    return state.productIds.contains(id);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  return FavoritesNotifier();
});
