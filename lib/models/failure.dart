/// Error type carried on the `Left` side of every `Either<Failure, T>`.
sealed class Failure {
  final String message;

  /// The partner API's `error.code` (e.g. `BAD_IBAN`), when it sent one —
  /// screens key their own localized copy off this instead of the raw message.
  final String? code;

  /// `error.details` when the API sends one (e.g. the courier stage that moved
  /// under us).
  final Map<String, dynamic>? details;

  const Failure(this.message, {this.code, this.details});
}

/// Any non-validation error (server error, timeout, parsing, 4xx/5xx).
class GeneralFailure extends Failure {
  const GeneralFailure(super.message, {super.code, super.details});
}

/// Device is offline / connection could not be established.
class NoInternetFailure extends Failure {
  const NoInternetFailure([super.message = 'No internet connection']);
}

/// HTTP 422 — per-field validation errors.
/// `errors` shape: `{ "phone": ["is invalid"] }`.
class ValidationFailure extends Failure {
  final Map<String, dynamic> errors;
  const ValidationFailure(super.message, this.errors,
      {super.code, super.details});

  /// First field message — handy for inline form hints.
  String? get firstError {
    if (errors.isEmpty) return null;
    final first = errors.values.first;
    if (first is List && first.isNotEmpty) return first.first.toString();
    return first.toString();
  }
}
