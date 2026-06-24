import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../models/chat_message.dart';
import '../../common/app_animations.dart';
import '../../common/app_colors.dart';
import '../../common/app_text_styles.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/app_text.dart';
import 'chat_viewmodel.dart';

class ChatView extends StackedView<ChatViewModel> {
  const ChatView({super.key});

  @override
  Widget builder(BuildContext context, ChatViewModel viewModel, Widget? child) {
    return FadeSlideIn(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 8),
          _Header(),
          Expanded(
            child: ListView(
              controller: viewModel.scrollController,
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 160),
              children: [
                for (final m in viewModel.messages) _Bubble(message: m),
                if (viewModel.sending) const _TypingBubble(),
                if (viewModel.showSuggestions) _Suggestions(viewModel: viewModel),
              ],
            ),
          ),
          _Composer(viewModel: viewModel),
        ],
      ),
    );
  }

  @override
  void onViewModelReady(ChatViewModel viewModel) => viewModel.init();

  @override
  ChatViewModel viewModelBuilder(BuildContext context) => ChatViewModel();
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.brand,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [BoxShadow(color: AppColors.brandShadow, blurRadius: 18, offset: Offset(0, 8))],
            ),
            child: const Center(child: AppIcon('sparkle', size: 24, color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.display('asst_title'.tr(), fontSize: 21, fontWeight: FontWeight.w600),
              const SizedBox(height: 3),
              Row(
                children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.online, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  AppText('asst_sub'.tr(), fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.muted),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final user = message.isUser;
    return Align(
      alignment: user ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        decoration: BoxDecoration(
          color: user ? AppColors.brand : AppColors.surface,
          borderRadius: BorderRadiusDirectional.only(
            topStart: const Radius.circular(18),
            topEnd: const Radius.circular(18),
            bottomStart: Radius.circular(user ? 18 : 6),
            bottomEnd: Radius.circular(user ? 6 : 18),
          ),
          boxShadow: user
              ? const [BoxShadow(color: AppColors.brandShadow, blurRadius: 18, offset: Offset(0, 8))]
              : const [BoxShadow(color: Color(0x26143232), blurRadius: 26, offset: Offset(0, 12))],
        ),
        child: AppText.body(
          message.text,
          fontSize: 15,
          height: 1.55,
          color: user ? Colors.white : AppColors.ink,
        ),
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();
  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(18),
            topEnd: Radius.circular(18),
            bottomStart: Radius.circular(6),
            bottomEnd: Radius.circular(18),
          ),
          boxShadow: [BoxShadow(color: Color(0x26143232), blurRadius: 26, offset: Offset(0, 12))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < 3; i++)
              AnimatedBuilder(
                animation: _c,
                builder: (_, __) {
                  final t = ((_c.value + i * 0.15) % 1.0);
                  final lift = t < 0.3 ? (t / 0.3) : (t < 0.6 ? (1 - (t - 0.3) / 0.3) : 0.0);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.5),
                    child: Transform.translate(
                      offset: Offset(0, -3 * lift),
                      child: Opacity(
                        opacity: 0.3 + 0.7 * lift,
                        child: Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppColors.faint, shape: BoxShape.circle)),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.viewModel});
  final ChatViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        for (final s in viewModel.suggestions)
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: GestureDetector(
              onTap: () => viewModel.send(s),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.line, width: 1.5),
                ),
                child: AppText(s, fontSize: 14.5, fontWeight: FontWeight.w600, color: AppColors.brand),
              ),
            ),
          ),
      ],
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.viewModel});
  final ChatViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, 96 + MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsetsDirectional.only(start: 18, end: 6, top: 6, bottom: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.line, width: 1.5),
          boxShadow: const [BoxShadow(color: Color(0x57143232), blurRadius: 28, offset: Offset(0, 12))],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: viewModel.inputController,
                cursorColor: AppColors.brand,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => viewModel.send(),
                style: AppTextStyles.body(context, fontSize: 15.5, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'asst_hint'.tr(),
                  hintStyle: AppTextStyles.body(context, fontSize: 15.5, fontWeight: FontWeight.w500, color: AppColors.faint),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => viewModel.send(),
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(color: AppColors.brand, shape: BoxShape.circle),
                child: const Center(child: AppIcon('send', size: 20, color: Colors.white, flipForRtl: true)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
