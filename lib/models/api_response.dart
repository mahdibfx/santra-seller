/// Generic envelope every [ApiService] returns.
///
/// The backend is expected to wrap all responses in:
/// ```json
/// { "success": true, "message": "...", "data": { ... }, "errors": { ... } }
/// ```
/// `data` is parsed by the [fromJsonT] callback passed to [ApiResponse.fromJson]
/// — that callback receives the **`data`** sub-object, not the whole body.
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int statusCode;

  /// Per-field validation errors (populated on HTTP 422). Shape:
  /// `{ "phone": ["is invalid"], "password": ["too short"] }`.
  final Map<String, dynamic> errors;

  const ApiResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    this.data,
    this.errors = const {},
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    int statusCode,
    T Function(dynamic data) fromJsonT,
  ) {
    final rawData = json['data'];
    return ApiResponse<T>(
      success: (json['success'] as bool?) ?? (statusCode >= 200 && statusCode < 300),
      message: (json['message'] as String?) ?? '',
      statusCode: statusCode,
      data: rawData == null ? null : fromJsonT(rawData),
      errors: (json['errors'] as Map<String, dynamic>?) ?? const {},
    );
  }

  /// Convenience for building a mocked success response from already-parsed
  /// data (used by the stub ApiServices until the backend is wired).
  factory ApiResponse.mock(T data, {String message = 'OK'}) => ApiResponse<T>(
        success: true,
        message: message,
        statusCode: 200,
        data: data,
      );
}
