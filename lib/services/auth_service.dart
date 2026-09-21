import 'package:fpdart/fpdart.dart';

import '../app/app.locator.dart';
import '../extensions/api_response_extension.dart';
import '../models/auth_tokens.dart';
import '../models/failure.dart';
import 'api/api_auth_service.dart';

/// Business wrapper for auth — converts `ApiResponse` to `Either<Failure, T>`.
class AuthService {
  final _api = locator<ApiAuthService>();

  Future<Either<Failure, Unit>> requestOtp({required String phone, String countryCode = '+971'}) =>
      _api.requestOtp(phone: phone, countryCode: countryCode).toEither();

  Future<Either<Failure, AuthTokens>> verifyOtp({
    required String phone,
    required String code,
    String countryCode = '+971',
  }) =>
      _api.verifyOtp(phone: phone, code: code, countryCode: countryCode).toEither();

  Future<Either<Failure, AuthTokens>> refresh(String refreshToken) =>
      _api.refresh(refreshToken).toEither();

  Future<Either<Failure, Unit>> logout(String refreshToken) =>
      _api.logout(refreshToken).toEither();

  Future<Either<Failure, Unit>> forgotPassword({required String phone}) =>
      _api.forgotPassword(phone: phone).toEither();

  Future<Either<Failure, Unit>> resetPassword({
    required String phone,
    required String code,
    required String password,
  }) =>
      _api.resetPassword(phone: phone, code: code, password: password).toEither();
}
