import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../domain/repositories/storage_repository.dart';

class FirebaseStorageRepository implements StorageRepository {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "profile_images");
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "profile_images");
  }

  /*
    HELPER METHODS - to upload files to storage
  */

  // Mobile platforms (file)
  Future<String?> _uploadFile(
    String path,
    String fileName,
    String folderName,
  ) async {
    try {
      // get file
      final file = File(path);

      // find place to store
      final storageRef = firebaseStorage.ref('$folderName/$fileName');

      // upload file
      final uploadTask = await storageRef.putFile(file);

      // get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  // Web Platforms (bytes)
  Future<String?> _uploadFileBytes(
    Uint8List fileBytes,
    String fileName,
    String folderName,
  ) async {
    try {
      // find place to store
      final storageRef = firebaseStorage.ref('$folderName/$fileName');

      // upload bytes
      final uploadTask = await storageRef.putData(fileBytes);

      // get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}
