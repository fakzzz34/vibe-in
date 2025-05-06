import 'dart:typed_data';

abstract class StorageRepository {
  // upload profile images on mobile
  Future<String?> uploadProfileImageMobile(String path, String fileName);

  // upload profile images on web

  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName);
}
