import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../models/chat_message.dart';
import '../../../models/order.dart';
import '../../../services/chat_service.dart';
import '../../../services/language_service.dart';
import '../../../services/orders_service.dart';

class ChatViewModel extends BaseViewModel {
  final _chatService = locator<ChatService>();
  final _ordersService = locator<OrdersService>();
  final _languageService = locator<LanguageService>();

  final inputController = TextEditingController();
  final scrollController = ScrollController();

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  List<Order> _orders = [];
  bool _sending = false;
  bool get sending => _sending;

  bool get showSuggestions => _messages.length <= 1 && !_sending;
  List<String> get suggestions => ['asst_s1'.tr(), 'asst_s2'.tr(), 'asst_s3'.tr()];

  Future<void> init() async {
    _messages.add(ChatMessage(role: ChatRole.assistant, text: 'asst_greeting'.tr()));
    rebuildUi();
    final result = await _ordersService.fetchOrders(limit: 100);
    result.fold((_) {}, (page) => _orders = page.items);
  }

  String get _orderContext => _orders.map((o) {
        final parts = <String>[
          '#${o.id}',
          o.customer,
          o.status.wire,
          o.payment.wire,
          o.tags.isEmpty ? 'standard' : o.tags.map((t) => t.wire).join('/'),
          'AED${o.total}',
        ];
        if (o.due != null) {
          parts.add(o.due! >= 0 ? 'due in ${o.due}m' : 'overdue by ${-o.due!}m');
        }
        parts.add('items: ${o.items.map((it) => '${it.name} x${it.qty}').join(', ')}');
        return parts.join(' · ');
      }).join('\n');

  Future<void> send([String? preset]) async {
    final text = (preset ?? inputController.text).trim();
    if (text.isEmpty || _sending) return;
    inputController.clear();
    _messages.add(ChatMessage(role: ChatRole.user, text: text));
    _sending = true;
    rebuildUi();
    _scrollToBottom();

    final result = await _chatService.sendMessage(
      messages: _messages,
      lang: _languageService.code,
      orderContext: _orderContext,
    );
    _sending = false;
    result.fold(
      (_) => _messages.add(ChatMessage(role: ChatRole.assistant, text: 'asst_error'.tr())),
      (reply) => _messages.add(ChatMessage(
        role: ChatRole.assistant,
        text: reply.trim().isEmpty ? 'asst_error'.tr() : reply.trim(),
      )),
    );
    rebuildUi();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
