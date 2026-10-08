import 'package:easy_localization/easy_localization.dart';

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

  /// What a shop should actually read.
  ///
  /// `error.message` is the API's English, written for us. Where the backend
  /// named a code a shop can act on, the app owns the wording in both
  /// languages; everything else falls through to the server's text.
  String get display => switch (code) {
        'SHOP_READ_ONLY' => 'err_shop_read_only'.tr(),
        'ACCOUNT_SUSPENDED' => 'err_account_suspended'.tr(),
        'APPLICATION_PENDING' => 'err_application_pending'.tr(),
        _ => message,
      };
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
