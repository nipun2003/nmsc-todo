

import 'dart:typed_data';

abstract class FileUploadRepository {
  // Repository methods would go here
  Future<String> uploadAvatar({
    required String userId,
    required Uint8List imageData,
  });
}