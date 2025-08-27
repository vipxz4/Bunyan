import 'package:bonyan/constants/firestore_collections.dart';
import 'package:bonyan/models/models.dart';
import 'package:bonyan/services/auth_service.dart';
import 'package:bonyan/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Single Object Providers ---

final userDetailsProvider = StreamProvider.autoDispose<UserModel?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  if (authState.asData?.value?.uid != null) {
    final firestoreService =
        ref.watch(firestoreServiceProvider(FirestoreCollections.users));
    return firestoreService.documentStream<UserModel?>(
      path: authState.asData!.value!.uid,
      builder: (data, documentId) =>
          data != null ? UserModel.fromJson(data, documentId) : null,
    );
  }
  return Stream.value(null);
});

// --- Stream-based List Providers ---

final allMyProjectsProvider =
    StreamProvider.autoDispose<List<ProjectModel>>((ref) {
  final user = ref.watch(userDetailsProvider).asData?.value;
  if (user == null) return Stream.value([]);

  final firestoreService =
      ref.watch(firestoreServiceProvider(FirestoreCollections.projects));
  return firestoreService.collectionStream<ProjectModel>(
    builder: (data, documentId) => ProjectModel.fromJson(data!, documentId),
    queryBuilder: (query) => query.where('userId', isEqualTo: user.id),
  );
});

final recommendedProfessionalsProvider =
    StreamProvider.autoDispose<List<ProfessionalModel>>((ref) {
  final firestoreService =
      ref.watch(firestoreServiceProvider(FirestoreCollections.professionals));
  return firestoreService.collectionStream<ProfessionalModel>(
    builder: (data, documentId) =>
        ProfessionalModel.fromJson(data!, documentId),
    queryBuilder: (query) => query.orderBy('rating', descending: true).limit(10),
  );
});

final productsProvider =
    StreamProvider.autoDispose<List<ProductModel>>((ref) {
  final firestoreService =
      ref.watch(firestoreServiceProvider(FirestoreCollections.products));
  return firestoreService.collectionStream<ProductModel>(
    builder: (data, documentId) => ProductModel.fromJson(data!, documentId),
  );
});

final notificationsProvider =
    StreamProvider.autoDispose<List<NotificationModel>>((ref) {
  final user = ref.watch(userDetailsProvider).asData?.value;
  if (user == null) return Stream.value([]);

  final firestoreService =
      ref.watch(firestoreServiceProvider(FirestoreCollections.notifications));
  return firestoreService.collectionStream<NotificationModel>(
      builder: (data, documentId) =>
          NotificationModel.fromJson(data!, documentId),
      queryBuilder: (query) => query
          .where('userId', isEqualTo: user.id)
          .orderBy('timestamp', descending: true));
});

final chatThreadsProvider =
    StreamProvider.autoDispose<List<ChatThreadModel>>((ref) {
  final user = ref.watch(userDetailsProvider).asData?.value;
  if (user == null) return Stream.value([]);

  final firestoreService =
      ref.watch(firestoreServiceProvider(FirestoreCollections.chats));
  return firestoreService.collectionStream<ChatThreadModel>(
    builder: (data, documentId) => ChatThreadModel.fromJson(data!, documentId),
    queryBuilder: (query) => query
        .where('participantIds', arrayContains: user.id)
        .orderBy('lastMessageTimestamp', descending: true),
  );
});

final myReviewsProvider = StreamProvider.autoDispose<List<ReviewModel>>((ref) {
  final user = ref.watch(userDetailsProvider).asData?.value;
  if (user == null) return Stream.value([]);

  final firestoreService =
      ref.watch(firestoreServiceProvider(FirestoreCollections.reviews));
  return firestoreService.collectionStream<ReviewModel>(
    builder: (data, documentId) => ReviewModel.fromJson(data!, documentId),
    queryBuilder: (query) =>
        query.where('authorId', isEqualTo: user.id).orderBy('date', descending: true),
  );
});

// --- Stream-based Family Providers for Details ---

final professionalDetailsProvider =
    StreamProvider.autoDispose.family<ProfessionalModel, String>((ref, id) {
  final firestoreService =
      ref.watch(firestoreServiceProvider(FirestoreCollections.professionals));
  return firestoreService.documentStream<ProfessionalModel>(
    path: id,
    builder: (data, documentId) =>
        ProfessionalModel.fromJson(data!, documentId),
  );
});

final supplierDetailsProvider =
    StreamProvider.autoDispose.family<SupplierModel, String>((ref, id) {
  final firestoreService =
      ref.watch(firestoreServiceProvider(FirestoreCollections.suppliers));
  return firestoreService.documentStream<SupplierModel>(
    path: id,
    builder: (data, documentId) => SupplierModel.fromJson(data!, documentId),
  );
});

final productDetailsProvider =
    StreamProvider.autoDispose.family<ProductModel, String>((ref, id) {
  final firestoreService =
      ref.watch(firestoreServiceProvider(FirestoreCollections.products));
  return firestoreService.documentStream<ProductModel>(
    path: id,
    builder: (data, documentId) => ProductModel.fromJson(data!, documentId),
  );
});

final chatMessagesProvider = StreamProvider.autoDispose
    .family<List<ChatMessageModel>, String>((ref, chatId) {
  final firestoreService = ref.watch(firestoreServiceProvider(
      '${FirestoreCollections.chats}/$chatId/${FirestoreCollections.messages}'));
  return firestoreService.collectionStream<ChatMessageModel>(
    builder: (data, documentId) => ChatMessageModel.fromJson(data!, documentId),
    queryBuilder: (query) => query.orderBy('timestamp', descending: true),
  );
});

// --- Actions Provider ---

class ProductsActions {
  ProductsActions(this.firestore);
  final FirebaseFirestore firestore;

  Future<void> addProduct(ProductModel product) async {
    await firestore
        .collection(FirestoreCollections.products)
        .add(product.toJson());
  }

  Future<void> editProduct(ProductModel product) async {
    await firestore
        .collection(FirestoreCollections.products)
        .doc(product.id)
        .update(product.toJson());
  }

  Future<void> deleteProduct(String productId) async {
    await firestore
        .collection(FirestoreCollections.products)
        .doc(productId)
        .delete();
  }
}

final productsActionsProvider = Provider<ProductsActions>((ref) {
  return ProductsActions(FirebaseFirestore.instance);
});

// --- Chat Actions Provider ---

class ChatActions {
  ChatActions(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> sendMessage({
    required String chatId,
    required String text,
    required String senderId,
  }) async {
    if (text.trim().isEmpty) return;

    final message = ChatMessageModel(
      id: '', // Firestore will generate
      text: text,
      timestamp: DateTime.now(),
      senderId: senderId,
      isMe: true, // This will be recalculated on read anyway
    );

    // Get a reference to the messages subcollection
    final messageRef = _firestore
        .collection(FirestoreCollections.chats)
        .doc(chatId)
        .collection(FirestoreCollections.messages);

    // Get a reference to the chat thread document
    final threadRef = _firestore.collection(FirestoreCollections.chats).doc(chatId);

    // Use a batch to perform both writes atomically
    final batch = _firestore.batch();

    batch.add(messageRef, message.toJson());
    batch.update(threadRef, {
      'lastMessage': text,
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }
}

final chatActionsProvider = Provider<ChatActions>((ref) {
  return ChatActions(FirebaseFirestore.instance);
});

// --- User Actions Provider ---

class UserActions {
  UserActions(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> updateUser(UserModel user) async {
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(user.id)
        .update(user.toJson());
  }
}

final userActionsProvider = Provider<UserActions>((ref) {
  return UserActions(FirebaseFirestore.instance);
});
