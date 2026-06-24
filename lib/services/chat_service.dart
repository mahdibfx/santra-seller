import 'package:fpdart/fpdart.dart';

import '../app/app.locator.dart';
import '../extensions/api_response_extension.dart';
import '../models/chat_message.dart';
import '../models/failure.dart';
import 'api/api_chat_service.dart';

class ChatService {
  final _api = locator<ApiChatService>();

  Future<Either<Failure, String>> sendMessage({
    required List<ChatMessage> messages,
    required String lang,
    String? orderContext,
  }) =>
      _api.sendMessage(messages: messages, lang: lang, orderContext: orderContext).toEither();
}
