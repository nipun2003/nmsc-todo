

import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {

  final _supabase = Supabase.instance.client;
  final String _defaultBucket = "nmsc_public";
  final String _avatarFolder = "avatars";

  Future<String> uploadAvatar({
    required String userId,
    required Uint8List fileBytes,
    String? contentType,
  }) async {
    final path = '$_avatarFolder/$userId/avatar.png';
    return await _uploadFile(
      bucket: _defaultBucket,
      path: path,
      fileBytes: fileBytes,
      contentType: contentType,
    );
  }

  Future<String> _uploadFile({
    required String bucket,
    required String path,
    required Uint8List fileBytes,
    String? contentType,
  }) async {
    return await _supabase.storage
        .from(bucket)
        .uploadBinary(path, fileBytes, fileOptions: FileOptions(contentType: contentType));
  }
}