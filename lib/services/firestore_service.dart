import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the FirestoreService.
// It's a family provider to be able to create instances for different collections.
final firestoreServiceProvider =
    Provider.family<FirestoreService, String>((ref, collectionPath) {
  return FirestoreService(collectionPath);
});

class FirestoreService {
  FirestoreService(this.collectionPath)
      : _firestore = FirebaseFirestore.instance;

  final String collectionPath;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(collectionPath);

  // Create a new document with a specific ID
  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    try {
      final reference = _firestore.doc(path);
      await reference.set(data, SetOptions(merge: merge));
    } on FirebaseException catch (e) {
      throw Exception('Error setting data: ${e.message}');
    }
  }

  // Create a new document with an auto-generated ID
  Future<DocumentReference<Map<String, dynamic>>> addData(
      Map<String, dynamic> data) async {
    try {
      return _collection.add(data);
    } on FirebaseException catch (e) {
      throw Exception('Error adding data: ${e.message}');
    }
  }

  // Delete a document
  Future<void> deleteData(String path) async {
    try {
      final reference = _firestore.doc(path);
      await reference.delete();
    } on FirebaseException catch (e) {
      throw Exception('Error deleting data: ${e.message}');
    }
  }

  // Get a stream of a single document
  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) {
    final reference = _collection.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) {
      // Explicitly handle the case where the document does not exist.
      if (!snapshot.exists) {
        return builder(null, snapshot.id);
      }
      return builder(snapshot.data(), snapshot.id);
    }).handleError((error) {
      // Re-throw the error with more context.
      throw Exception('Error in document stream for path $path: $error');
    });
  }

  // Get a stream of a collection
  Stream<List<T>> collectionStream<T>({
    required T Function(Map<String, dynamic>? data, String documentID) builder,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query<Map<String, dynamic>> query = _collection;
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      try {
        final result = snapshot.docs
            .map((snapshot) => builder(snapshot.data(), snapshot.id))
            .where((value) => value != null)
            .toList();
        if (sort != null) {
          result.sort(sort);
        }
        return result;
      } catch (e) {
        // Errors inside the builder function should be caught.
        throw Exception('Error mapping collection stream: $e');
      }
    }).handleError((error) {
      // Handles errors from the stream itself (e.g., permissions)
      throw Exception('Error in collection stream: $error');
    });
  }

  // Get a single document
  Future<T> getDocument<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) async {
    try {
      final reference = _collection.doc(path);
      final snapshot = await reference.get();
      return builder(snapshot.data(), snapshot.id);
    } on FirebaseException catch (e) {
      throw Exception('Error getting document: ${e.message}');
    }
  }

  // Get a collection of documents
  Future<List<T>> getCollection<T>({
    required T Function(Map<String, dynamic>? data, String documentID) builder,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _collection;
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      final snapshot = await query.get();
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    } on FirebaseException catch (e) {
      throw Exception('Error getting collection: ${e.message}');
    }
  }
}
