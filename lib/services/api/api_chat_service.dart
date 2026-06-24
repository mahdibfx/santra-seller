import '../../models/api_response.dart';
import '../../models/chat_message.dart';
import 'api_endpoints.dart';

/// Assistant (AI chat) HTTP layer.
///
/// STUB: returns a canned reply. The backend should proxy to an LLM
/// (e.g. Claude) server-side — never embed model credentials in the app.
class ApiChatService {
  // final _dio = locator<DioService>().dio;

  /// POST [ApiEndpoints.assistant]
  /// Request:
  /// ```json
  /// { "lang": "en",
  ///   "order_context": "<compact live order board text>",
  ///   "messages": [ { "role": "user|assistant", "content": "…" } ] }
  /// ```
  /// Response: `{ "success": true, "data": { "reply": "<assistant text>" } }`
  Future<ApiResponse<String>> sendMessage({
    required List<ChatMessage> messages,
    required String lang,
    String? orderContext,
  }) async {
    // final res = await _dio.post(ApiEndpoints.assistant, data: {
    //   'lang': lang,
    //   'order_context': orderContext,
    //   'messages': messages.map((m) => m.toApiJson()).toList(),
    // });
    // return ApiResponse<String>.fromJson(res.data as Map<String, dynamic>, res.statusCode!, (d) => d['reply'] as String);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final reply = lang == 'ar'
        ? 'لديك ٣ طلبات قيد الانتظار اليوم بقيمة إجمالية 440 د.إ. الطلب #1041 هو الأكثر إلحاحاً (سريع، يجب توصيله قبل الساعة 4 مساءً). أنصح بقبوله أولاً ثم البدء بتجهيز كيكة الفستق للطلب #1042. 🍰'
        : 'You have 3 pending orders today totaling AED 440. #1041 is most urgent (Express, due before 4 PM) — accept it first, then start the pistachio cake for #1042. Want help drafting a message to either customer? 🍰';
    return ApiResponse<String>.mock(reply);
  }
}
