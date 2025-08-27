import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bonyan/data/mock_data.dart';
import 'package:bonyan/models/models.dart';
import 'package:collection/collection.dart';

// --- Single Object Providers ---
final userProvider = Provider<UserModel>((ref) => mockUser);

// --- List Providers ---
final activeProjectsProvider =
    Provider<List<ProjectModel>>((ref) => mockActiveProjects);
final allMyProjectsProvider =
    Provider<List<ProjectModel>>((ref) => mockAllMyProjects);
final recommendedProfessionalsProvider =
    Provider<List<ProfessionalModel>>((ref) => mockRecommendedProfessionals);

class ProductsNotifier extends StateNotifier<List<ProductModel>> {
  ProductsNotifier() : super(mockProducts);

  void addProduct(ProductModel product) {
    state = [...state, product];
  }

  void editProduct(ProductModel updatedProduct) {
    state = [
      for (final product in state)
        if (product.id == updatedProduct.id) updatedProduct else product,
    ];
  }

  void deleteProduct(String productId) {
    state = state.where((product) => product.id != productId).toList();
  }
}

final productsProvider =
    StateNotifierProvider<ProductsNotifier, List<ProductModel>>(
        (ref) => ProductsNotifier());

final notificationsProvider =
    Provider<List<NotificationModel>>((ref) => mockNotifications);
final chatThreadsProvider =
    Provider<List<ChatThreadModel>>((ref) => mockChatThreads);
final myReviewsProvider = Provider<List<ReviewModel>>((ref) => mockMyReviews);

// --- Family Providers for Details ---

final professionalDetailsProvider =
    FutureProvider.family<ProfessionalModel?, String>((ref, id) async {
  return mockRecommendedProfessionals.firstWhereOrNull((p) => p.id == id);
});

final supplierDetailsProvider =
    FutureProvider.family<SupplierModel?, String>((ref, id) async {
  // For now, we only have one mock supplier.
  if (id == mockSupplier.id) return mockSupplier;
  return null;
});

final productDetailsProvider =
    FutureProvider.family<ProductModel?, String>((ref, id) async {
  return mockProducts.firstWhereOrNull((p) => p.id == id);
});

final chatMessagesProvider =
    Provider.family<List<ChatMessageModel>, String>((ref, chatId) {
  return mockChatMessages[chatId] ?? [];
});
