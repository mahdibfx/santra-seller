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
      return left(GeneralFailure(res.message.isEmpty ? 'Something went wrong' : res.message));
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
      final code = e.response?.statusCode ?? 0;
      final body = e.response?.data;
      final message = (body is Map && body['message'] is String)
          ? body['message'] as String
          : null;
      switch (code) {
        case 401:
          return GeneralFailure(message ?? 'Your session has expired.');
        case 403:
          return GeneralFailure(message ?? 'You are not allowed to do that.');
        case 404:
          return GeneralFailure(message ?? 'Not found.');
        case 422:
          final errors = (body is Map && body['errors'] is Map)
              ? Map<String, dynamic>.from(body['errors'] as Map)
              : <String, dynamic>{};
          return ValidationFailure(message ?? 'Validation failed', errors);
        default:
          return GeneralFailure(message ?? 'Server error ($code).');
      }
    default:
      return GeneralFailure(e.message ?? 'Something went wrong.');
  }
}
