import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/promotion_request.dart';
import '../../../services/promotions_service.dart';
import '../../../services/toast_service.dart';

class PromotionRequestsViewModel extends BaseViewModel {
  final _promotionsService = locator<PromotionsService>();
  final _navigationService = locator<NavigationService>();
  final _toastService = locator<ToastService>();

  List<PromotionRequest> _requests = [];
  List<PromotionRequest> get requests => _requests;

  int get actionCount => _requests.where((r) => r.needsAction).length;

  Future<void> init() async {
    setBusy(true);
    final result = await _promotionsService.fetchRequests();
    result.fold(
      (failure) => _toastService.showUpperToast(failure.display, type: ToastType.danger),
      (list) => _requests = list,
    );
    setBusy(false);
  }

  Future<void> onOpen(PromotionRequest r) async {
    await _navigationService.navigateToPromotionRequestDetailView(requestId: r.id);
    await init(); // reflect the answer when returning
  }

  void onBack() => _navigationService.back();
}
