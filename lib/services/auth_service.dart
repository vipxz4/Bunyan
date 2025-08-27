import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bonyan/utils/error_handler.dart';

class AuthService {
  AuthService(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(handleAuthException(e));
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(handleAuthException(e));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> createUserDocument({
    required String uid,
    required String fullName,
    required String email,
    required String role,
  }) async {
    try {
      // Create a document with initial fields, initializing all possible
      // fields to a default state to ensure type safety on reads.
      await _firestore.collection('users').doc(uid).set({
        'fullName': fullName,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
        // Initialize other fields to their default/empty state.
        'phoneNumber': null,
        'avatarUrl': null,
        'favoriteProductIds': [],
        'favoriteProfessionalIds': [],
        'companyName': null,
        'address': null,
        'specialization': null,
        'yearsOfExperience': null,
      });
    } on FirebaseException catch (e) {
      // In a real app, handle this error more gracefully
      throw Exception('Failed to create user document: ${e.message}');
    }
  }
}

// Provider for the FirebaseAuth instance
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// Provider for the FirebaseFirestore instance
final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// Provider for the AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    ref.watch(firebaseAuthProvider),
    ref.watch(firestoreProvider),
  );
});

// Provider that streams the authentication state
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});
