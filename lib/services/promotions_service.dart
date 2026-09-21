import 'package:fpdart/fpdart.dart';

import '../app/app.locator.dart';
import '../extensions/api_response_extension.dart';
import '../models/failure.dart';
import '../models/promotion_request.dart';
import 'api/api_promotions_service.dart';

class PromotionsService {
  final _api = locator<ApiPromotionsService>();

  Future<Either<Failure, List<PromotionRequest>>> fetchRequests() =>
      _api.fetchRequests().toEither();

  Future<Either<Failure, PromotionRequest>> fetchRequest(int id) =>
      _api.fetchRequest(id).toEither();

  Future<Either<Failure, Unit>> respond(
    int id, {
    String? stock,
    String? stockNote,
    bool? signatureAccept,
    String? fullName,
    String? declineReason,
  }) =>
      _api
          .respond(id,
              stock: stock,
              stockNote: stockNote,
              signatureAccept: signatureAccept,
              fullName: fullName,
              declineReason: declineReason)
          .toEither();
}
