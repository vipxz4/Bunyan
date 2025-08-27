import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageService {
  final FirebaseStorage _storage;

  StorageService(this._storage);

  Future<String> uploadProfilePicture({
    required String uid,
    required File file,
  }) async {
    try {
      // Create a reference to the location you want to upload to.
      // Using a timestamp ensures that even if a user uploads a file with the same name,
      // it won't overwrite the old one (useful for other upload types, though less so for profile pics).
      final fileExtension = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final ref = _storage.ref('profile_pictures/$uid/$fileName');

      // Upload the file
      final uploadTask = ref.putFile(file);

      // Wait for the upload to complete
      final snapshot = await uploadTask.whenComplete(() => {});

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      // Handle errors
      throw Exception('Error uploading profile picture: ${e.message}');
    }
  }
}

// Provider for the FirebaseStorage instance
final firebaseStorageProvider = Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);

// Provider for our StorageService
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref.watch(firebaseStorageProvider));
});
