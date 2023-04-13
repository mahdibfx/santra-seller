import 'package:envify/envify.dart';
part 'env.g.dart';

@Envify(name: 'Secret', path: '.env')
abstract class Secret {
  /// Holds the API_KEY.
  static const api_key_url = _Secret.api_key_url;
  static const api_key = _Secret.api_key;

  /// Holds the CLIENT_SECRET.
  static const client_secret = _Secret.client_secret;
}
