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
final productsProvider = Provider<List<ProductModel>>((ref) => mockProducts);
final notificationsProvider =
    Provider<List<NotificationModel>>((ref) => mockNotifications);
final chatThreadsProvider =
    Provider<List<ChatThreadModel>>((ref) => mockChatThreads);
final myReviewsProvider = Provider<List<ReviewModel>>((ref) => mockMyReviews);

// --- Family Providers for Details ---

final professionalDetailsProvider =
    Provider.family<ProfessionalModel?, String>((ref, id) {
  return mockRecommendedProfessionals.firstWhereOrNull((p) => p.id == id);
});

final supplierDetailsProvider =
    Provider.family<SupplierModel?, String>((ref, id) {
  // For now, we only have one mock supplier.
  if (id == mockSupplier.id) return mockSupplier;
  return null;
});

final productDetailsProvider =
    Provider.family<ProductModel?, String>((ref, id) {
  return mockProducts.firstWhereOrNull((p) => p.id == id);
});

final chatMessagesProvider =
    Provider.family<List<ChatMessageModel>, String>((ref, chatId) {
  return mockChatMessages[chatId] ?? [];
});
