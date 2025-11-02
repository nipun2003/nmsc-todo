

class FileUploadException implements Exception {
  final String message;
  FileUploadException(this.message);

  @override
  String toString() => 'FileUploadException: $message';
}