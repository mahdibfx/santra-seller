import 'package:fpdart/fpdart.dart';

import '../app/app.locator.dart';
import '../extensions/api_response_extension.dart';
import '../models/failure.dart';
import '../models/seller_profile.dart';
import '../models/trading.dart';
import 'api/api_profile_service.dart';

class ProfileService {
  final _api = locator<ApiProfileService>();

  Future<Either<Failure, SellerProfile>> fetchProfile() =>
      _api.fetchProfile().toEither();

  Future<Either<Failure, Trading>> updateTrading(
          {required String action, Object? minutes}) =>
      _api.updateTrading(action: action, minutes: minutes).toEither();

  Future<Either<Failure, Unit>> logout() => _api.logout().toEither();
}
