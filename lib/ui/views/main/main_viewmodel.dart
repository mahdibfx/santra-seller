import 'package:stacked/stacked.dart';

class MainViewModel extends BaseViewModel {
  // 0 = profile, 1 = orders, 2 = chat  (matches BottomNav order; default Orders).
  int _index = 1;
  int get index => _index;

  static const _keys = ['profile', 'orders', 'chat'];
  String get activeKey => _keys[_index];

  void onNavigate(String key) {
    final i = _keys.indexOf(key);
    if (i == -1 || i == _index) return;
    _index = i;
    rebuildUi();
  }
}
