


/// Represents a sealed result, which is either a success with data (T)
/// or a failure with an error type (E) and message.
sealed class CustomResponse<T, E> {
  // Base class properties are all nullable, as only one branch will use them.
  final T? data;
  final String? message;
  final E? errorType;

  // Private constructor to force instantiation via subclasses
  const CustomResponse({
    required this.data, 
    required this.message, 
    required this.errorType,
  });
}

// 1. SUCCESS: Holds data (T), but no error information.
// We keep the Error type (E) in the subclass definition for consistency,
// but ensure it's null in the super call.
final class SuccessResponse<T, E> extends CustomResponse<T, E> {
  // Use a required positional argument for data, as success MUST have data.
  const SuccessResponse(T data)
      : super(
          data: data,
          message: null,
          errorType: null,
        );
}

// 2. ERROR: Holds error info (message/E), but no data (T).
// We keep the Data type (T) in the subclass definition for consistency,
// but ensure it's null in the super call.
final class ErrorResponse<T, E> extends CustomResponse<T, E> {
  // Use required positional arguments for message and errorType.
  const ErrorResponse(String message, E errorType)
      : super(
          data: null,
          message: message,
          errorType: errorType,
        );
}