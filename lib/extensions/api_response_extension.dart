import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../models/api_response.dart';
import '../models/failure.dart';

/// Converts a `Future<ApiResponse<T>>` into a `Future<Either<Failure, T>>`.
///
/// This is the single seam where HTTP/transport concerns become functional
/// error values. Call it **only** in the business `Service` layer — never in a
/// ViewModel.
extension ApiResponseX<T> on Future<ApiResponse<T>> {
  Future<Either<Failure, T>> toEither() async {
    try {
      final res = await this;
      if (res.success) {
        return right(res.data as T);
      }
      if (res.errors.isNotEmpty) {
        return left(ValidationFailure(
          res.message.isEmpty ? 'Validation failed' : res.message,
          res.errors,
        ));
      }
      return left(GeneralFailure(
          res.message.isEmpty ? 'Something went wrong' : res.message));
    } on DioException catch (e) {
      return left(_mapDioException(e));
    } catch (e) {
      return left(GeneralFailure(e.toString()));
    }
  }
}

Failure _mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const GeneralFailure('The request timed out. Please try again.');
    case DioExceptionType.connectionError:
      return const NoInternetFailure();
    case DioExceptionType.badResponse:
      final httpCode = e.response?.statusCode ?? 0;
      final body = e.response?.data;
      // Partner API error shape: { "error": { "code": "...", "message": "..." } }
      final error =
          (body is Map && body['error'] is Map) ? body['error'] as Map : null;
      final message =
          error?['message'] is String ? error!['message'] as String : null;
      final code = error?['code'] is String ? error!['code'] as String : null;
      final details = error?['details'] is Map
          ? (error!['details'] as Map).cast<String, dynamic>()
          : null;
      switch (httpCode) {
        case 400:
        case 422:
          // VALIDATION_ERROR — single message names the bad field.
          return ValidationFailure(message ?? 'Validation failed', const {},
              code: code, details: details);
        case 401:
          return GeneralFailure(message ?? 'Your session has expired.',
              code: code, details: details);
        case 403:
          return GeneralFailure(message ?? 'You are not allowed to do that.',
              code: code, details: details);
        case 404:
          return GeneralFailure(message ?? 'Not found.',
              code: code, details: details);
        case 409:
          return GeneralFailure(message ?? 'That change is not allowed.',
              code: code, details: details);
        case 429:
          return GeneralFailure(
              message ?? 'Too many requests — please wait a moment.',
              code: code,
              details: details);
        default:
          return GeneralFailure(message ?? 'Server error ($httpCode).',
              code: code, details: details);
      }
    default:
      return GeneralFailure(e.message ?? 'Something went wrong.');
  }
}
