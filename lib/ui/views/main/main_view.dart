import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_colors.dart';
import '../../widgets/bottom_nav.dart';
import '../chat/chat_view.dart';
import '../orders/orders_view.dart';
import '../profile/profile_view.dart';
import 'main_viewmodel.dart';

/// App shell after login: Profile · Orders · Assistant, with a floating nav.
class MainView extends StackedView<MainViewModel> {
  const MainView({super.key});

  @override
  Widget builder(BuildContext context, MainViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          Positioned.fill(
            // Keyed on the locale: the three pages live in a const IndexedStack
            // and would otherwise keep their English `.tr()` strings after a
            // language switch — only the RTL direction would flip.
            child: IndexedStack(
              key: ValueKey(context.locale.languageCode),
              index: viewModel.index,
              children: const [
                ProfileView(),
                OrdersView(),
                ChatView(),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNav(
                active: viewModel.activeKey, onNavigate: viewModel.onNavigate),
          ),
        ],
      ),
    );
  }

  @override
  MainViewModel viewModelBuilder(BuildContext context) => MainViewModel();
}
