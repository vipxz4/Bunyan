import 'package:bonyan/constants/firestore_collections.dart';
import 'package:bonyan/models/models.dart';
import 'package:bonyan/providers/data_providers.dart';
import 'package:bonyan/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider simply exposes the list of favorite professional IDs from the current user.
final favoriteProfessionalIdsProvider = Provider<List<String>>((ref) {
  return ref.watch(userDetailsProvider).asData?.value?.favoriteProfessionalIds ?? [];
});

// This provider exposes the list of favorite product IDs from the current user.
final favoriteProductIdsProvider = Provider<List<String>>((ref) {
  return ref.watch(userDetailsProvider).asData?.value?.favoriteProductIds ?? [];
});


// New, efficient provider that fetches full ProfessionalModel objects
final favoriteProfessionalsProvider = StreamProvider.autoDispose<List<ProfessionalModel>>((ref) {
  final favoriteIds = ref.watch(favoriteProfessionalIdsProvider);
  if (favoriteIds.isEmpty) {
    return Stream.value([]);
  }

  final firestoreService = ref.watch(firestoreServiceProvider(FirestoreCollections.professionals));
  return firestoreService.collectionStream<ProfessionalModel>(
    builder: (data, documentId) => ProfessionalModel.fromJson(data!, documentId),
    queryBuilder: (query) => query.where(FieldPath.documentId, whereIn: favoriteIds),
  );
});


// New, efficient provider that fetches full ProductModel objects
final favoriteProductsProvider = StreamProvider.autoDispose<List<ProductModel>>((ref) {
  final favoriteIds = ref.watch(favoriteProductIdsProvider);
  if (favoriteIds.isEmpty) {
    return Stream.value([]);
  }

  final firestoreService = ref.watch(firestoreServiceProvider(FirestoreCollections.products));
  return firestoreService.collectionStream<ProductModel>(
    builder: (data, documentId) => ProductModel.fromJson(data!, documentId),
    queryBuilder: (query) => query.where(FieldPath.documentId, whereIn: favoriteIds),
  );
});
