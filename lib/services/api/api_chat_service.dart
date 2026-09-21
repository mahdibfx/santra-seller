import '../../app/app.locator.dart';
import '../../models/api_response.dart';
import '../../models/chat_message.dart';
import '../dio_service.dart';
import 'api_endpoints.dart';

class ApiChatService {
  final _dio = locator<DioService>().dio;

  Future<ApiResponse<String>> sendMessage({
    required List<ChatMessage> messages,
    required String lang,
    String? orderContext,
  }) async {
    final res = await _dio.post(ApiEndpoints.assistant, data: {
      'lang': lang,
      'order_context': orderContext,
      'messages': messages.map((m) => m.toApiJson()).toList(),
    });
    return ApiResponse<String>.fromJson(
        res.data as Map<String, dynamic>, res.statusCode!, (d) => d['reply'] as String);
  }
}
