enum ChatRole { user, assistant }

class ChatMessage {
  final ChatRole role;
  final String text;

  const ChatMessage({required this.role, required this.text});

  bool get isUser => role == ChatRole.user;

  Map<String, dynamic> toApiJson() => {
        'role': role == ChatRole.user ? 'user' : 'assistant',
        'content': text,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        role: (json['role'] as String?) == 'user' ? ChatRole.user : ChatRole.assistant,
        text: json['text'] as String? ?? json['content'] as String? ?? '',
      );
}
