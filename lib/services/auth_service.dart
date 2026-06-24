import 'package:fpdart/fpdart.dart';

import '../app/app.locator.dart';
import '../extensions/api_response_extension.dart';
import '../models/failure.dart';
import 'api/api_auth_service.dart';

/// Business wrapper for auth — converts `ApiResponse` to `Either<Failure, T>`.
class AuthService {
  final _api = locator<ApiAuthService>();

  Future<Either<Failure, Unit>> requestOtp({required String phone}) =>
      _api.requestOtp(phone: phone).toEither();

  Future<Either<Failure, String>> verifyOtp({required String phone, required String code}) =>
      _api.verifyOtp(phone: phone, code: code).toEither();

  Future<Either<Failure, Unit>> forgotPassword({required String phone}) =>
      _api.forgotPassword(phone: phone).toEither();

  Future<Either<Failure, Unit>> resetPassword({
    required String phone,
    required String code,
    required String password,
  }) =>
      _api.resetPassword(phone: phone, code: code, password: password).toEither();
}
