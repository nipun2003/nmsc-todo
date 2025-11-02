

import 'package:flutter/foundation.dart';
import 'package:nmsc_todo/data/remote/service/supabase_storage_service.dart';
import 'package:nmsc_todo/domain/repository/file_upload_repository.dart';
import 'package:nmsc_todo/domain/utils/exception/file_upload_exception.dart';

class FileUploadRepositoryImpl implements FileUploadRepository {

  final SupabaseStorageService _storageService;
  FileUploadRepositoryImpl(this._storageService);
 

 @override
  Future<String> uploadAvatar({required String userId, required Uint8List imageData}) async{
   try {
    final imageUrl = await _storageService.uploadAvatar(userId: userId, fileBytes: imageData);
    if(kDebugMode){
      print("Avatar uploaded successfully for User ID: $userId, URL: $imageUrl");
    }
    return imageUrl;
   } catch (e) {
    throw FileUploadException("Failed to upload file: ${e.toString()}");
   }
  }
}