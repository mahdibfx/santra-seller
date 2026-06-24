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
            child: IndexedStack(
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
            child: BottomNav(active: viewModel.activeKey, onNavigate: viewModel.onNavigate),
          ),
        ],
      ),
    );
  }

  @override
  MainViewModel viewModelBuilder(BuildContext context) => MainViewModel();
}
