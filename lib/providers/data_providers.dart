import 'package:bonyan/constants/firestore_collections.dart';
import 'package:bonyan/models/models.dart';
import 'package:bonyan/models/search_result_model.dart';
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
    queryBuilder: (query) =>
        query.orderBy('rating', descending: true).limit(10),
  );
});

final productsProvider = StreamProvider.autoDispose<List<ProductModel>>((ref) {
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

// This provider is correctly implemented to handle Firestore's query limitations.
final chatThreadsProvider =
    StreamProvider.autoDispose<List<ChatThreadModel>>((ref) {
  final user = ref.watch(userDetailsProvider).asData?.value;
  if (user == null) return Stream.value([]);

  final firestoreService =
      ref.watch(firestoreServiceProvider(FirestoreCollections.chats));

  // 1. Fetch the stream without ordering from Firestore because 'array-contains'
  // cannot be combined with 'orderBy' on a different field.
  final stream = firestoreService.collectionStream<ChatThreadModel>(
    builder: (data, documentId) => ChatThreadModel.fromJson(data!, documentId),
    queryBuilder: (query) =>
        query.where('participantIds', arrayContains: user.id),
  );

  // 2. Sort the list on the client-side, which is the correct workaround.
  return stream.map((threads) {
    threads.sort(
        (a, b) => b.lastMessageTimestamp.compareTo(a.lastMessageTimestamp));
    return threads;
  });
});

final myReviewsProvider = StreamProvider.autoDispose<List<ReviewModel>>((ref) {
  final user = ref.watch(userDetailsProvider).asData?.value;
  if (user == null) return Stream.value([]);

  final firestoreService =
      ref.watch(firestoreServiceProvider(FirestoreCollections.reviews));
  return firestoreService.collectionStream<ReviewModel>(
    builder: (data, documentId) => ReviewModel.fromJson(data!, documentId),
    queryBuilder: (query) => query
        .where('authorId', isEqualTo: user.id)
        .orderBy('date', descending: true),
  );
});

final reviewsForProfessionalProvider = StreamProvider.autoDispose
    .family<List<ReviewModel>, String>((ref, professionalId) {
  final firestoreService =
      ref.watch(firestoreServiceProvider(FirestoreCollections.reviews));
  return firestoreService.collectionStream<ReviewModel>(
    builder: (data, documentId) => ReviewModel.fromJson(data!, documentId),
    queryBuilder: (query) => query
        .where('targetId', isEqualTo: professionalId)
        .orderBy('date', descending: true),
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
  ChatActions(this._firestore, this._ref);
  final FirebaseFirestore _firestore;
  final Ref _ref;

  Future<String> findOrCreateChat(String otherUserId) async {
    final currentUser = _ref.read(userDetailsProvider).asData?.value;
    if (currentUser == null) throw Exception('User not logged in');

    final currentUserId = currentUser.id;
    final members = [currentUserId, otherUserId]
      ..sort(); // Sort to create a consistent ID

    final chatQuery = await _firestore
        .collection(FirestoreCollections.chats)
        .where('participantIds', isEqualTo: members)
        .limit(1)
        .get();

    if (chatQuery.docs.isNotEmpty) {
      return chatQuery.docs.first.id;
    } else {
      // Create a new chat
      final newChat = ChatThreadModel(
        id: '', // Firestore will generate
        participantIds: members,
        otherPartyName: 'New Chat', // Placeholder
        lastMessage: 'Chat created.',
        lastMessageTimestamp: DateTime.now(),
        unreadCount: 0,
        isOnline: false,
      );
      final docRef = await _firestore
          .collection(FirestoreCollections.chats)
          .add(newChat.toJson());
      return docRef.id;
    }
  }

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

    final messageRef = _firestore
        .collection(FirestoreCollections.chats)
        .doc(chatId)
        .collection(FirestoreCollections.messages);

    final threadRef =
        _firestore.collection(FirestoreCollections.chats).doc(chatId);

    final batch = _firestore.batch();

    // This is the correct way to add a new document in a batch.
    final newMessageDoc = messageRef.doc();
    batch.set(newMessageDoc, message.toJson());

    batch.update(threadRef, {
      'lastMessage': text,
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }
}

final chatActionsProvider = Provider<ChatActions>((ref) {
  return ChatActions(FirebaseFirestore.instance, ref);
});

// --- User Actions Provider ---

class UserActions {
  UserActions(this._firestore, this._ref);
  final FirebaseFirestore _firestore;
  final Ref _ref;

  Future<void> updateUser(UserModel user) async {
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(user.id)
        .update(user.toJson());
  }

  Future<void> toggleProfessionalFavorite(String professionalId) async {
    final user = _ref.read(userDetailsProvider).asData?.value;
    if (user == null) throw Exception('User not logged in');

    final isFavorite = user.favoriteProfessionalIds.contains(professionalId);
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(user.id)
        .update({
      'favoriteProfessionalIds': isFavorite
          ? FieldValue.arrayRemove([professionalId])
          : FieldValue.arrayUnion([professionalId]),
    });
  }

  Future<void> toggleProductFavorite(String productId) async {
    final user = _ref.read(userDetailsProvider).asData?.value;
    if (user == null) throw Exception('User not logged in');

    final isFavorite = user.favoriteProductIds.contains(productId);
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(user.id)
        .update({
      'favoriteProductIds': isFavorite
          ? FieldValue.arrayRemove([productId])
          : FieldValue.arrayUnion([productId]),
    });
  }
}

final userActionsProvider = Provider<UserActions>((ref) {
  return UserActions(FirebaseFirestore.instance, ref);
});

// --- Notification Actions Provider ---

class NotificationActions {
  NotificationActions(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> markAsRead(String notificationId) async {
    await _firestore
        .collection(FirestoreCollections.notifications)
        .doc(notificationId)
        .update({'isRead': true});
  }
}

final notificationActionsProvider = Provider<NotificationActions>((ref) {
  return NotificationActions(FirebaseFirestore.instance);
});

// --- Search Provider ---

// This provider is correctly implemented for performance.
final generalSearchProvider = FutureProvider.autoDispose
    .family<List<SearchResult>, String>((ref, query) async {
  if (query.isEmpty) {
    return [];
  }

  final lowerCaseQuery = query.toLowerCase();

  // Using ref.read() here is the correct approach to prevent re-fetching on rebuilds.
  final productSearchFuture = ref
      .read(firestoreServiceProvider(FirestoreCollections.products))
      .getCollection<SearchResult>(
        builder: (data, documentId) =>
            SearchResult(product: ProductModel.fromJson(data!, documentId)),
        queryBuilder: (q) => q
            .where('name', isGreaterThanOrEqualTo: lowerCaseQuery)
            .where('name', isLessThanOrEqualTo: '$lowerCaseQuery\uf8ff'),
      );

  final professionalSearchFuture = ref
      .read(firestoreServiceProvider(FirestoreCollections.professionals))
      .getCollection<SearchResult>(
        builder: (data, documentId) => SearchResult(
            professional: ProfessionalModel.fromJson(data!, documentId)),
        queryBuilder: (q) => q
            .where('name', isGreaterThanOrEqualTo: lowerCaseQuery)
            .where('name', isLessThanOrEqualTo: '$lowerCaseQuery\uf8ff'),
      );

  final results =
      await Future.wait([productSearchFuture, professionalSearchFuture]);

  // Flatten the list of lists into a single list
  return results.expand((list) => list).toList();
});