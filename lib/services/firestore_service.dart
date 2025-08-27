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
    final reference = _firestore.doc(path);
    await reference.set(data, SetOptions(merge: merge));
  }

  // Create a new document with an auto-generated ID
  Future<DocumentReference<Map<String, dynamic>>> addData(
      Map<String, dynamic> data) async {
    return _collection.add(data);
  }

  // Delete a document
  Future<void> deleteData(String path) async {
    final reference = _firestore.doc(path);
    await reference.delete();
  }

  // Get a stream of a single document
  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) {
    final reference = _firestore.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
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
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  // Get a single document
  Future<T> getDocument<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) async {
    final reference = _firestore.doc(path);
    final snapshot = await reference.get();
    return builder(snapshot.data(), snapshot.id);
  }

  // Get a collection of documents
  Future<List<T>> getCollection<T>({
    required T Function(Map<String, dynamic>? data, String documentID) builder,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) async {
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
  }
}
