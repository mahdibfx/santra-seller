import 'package:shared_preferences/shared_preferences.dart';

import '../app/app.locator.dart';
import 'dio_service.dart';

class TokenService {
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _nameKey = 'partner_name';
  static const _nameArKey = 'partner_name_ar';

  String? _token;
  String? _refreshToken;
  String? get token => _token;
  String? get refreshToken => _refreshToken;
  bool get isLoggedIn => _token != null;

  /// Business name captured at login — the profile screen's name source.
  String partnerName = '';
  String partnerNameAr = '';

  String partnerDisplayName(String lang) =>
      lang == 'ar' && partnerNameAr.isNotEmpty ? partnerNameAr : partnerName;

  Future<void> savePartnerName(String nameEn, String nameAr) async {
    if (nameEn.isEmpty && nameAr.isEmpty) return;
    partnerName = nameEn;
    partnerNameAr = nameAr;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, nameEn);
    await prefs.setString(_nameArKey, nameAr);
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_accessKey);
    _refreshToken = prefs.getString(_refreshKey);
    partnerName = prefs.getString(_nameKey) ?? '';
    partnerNameAr = prefs.getString(_nameArKey) ?? '';
    if (_token != null) {
      locator<DioService>().setAuthToken(_token!);
    }
  }

  // Access token lives ~15 min; DioService's interceptor auto-refreshes it via
  // the refresh token on a 401 and retries, logging out only if refresh fails.
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    _token = accessToken;
    _refreshToken = refreshToken;
    locator<DioService>().setAuthToken(accessToken);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, accessToken);
    await prefs.setString(_refreshKey, refreshToken);
  }

  Future<void> clearToken() async {
    _token = null;
    _refreshToken = null;
    partnerName = '';
    partnerNameAr = '';
    locator<DioService>().clearAuthToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_nameArKey);
  }
}
