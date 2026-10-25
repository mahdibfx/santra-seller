import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santra_seller/ui/widgets/swipe_to_confirm.dart';

/// The whole point of this control is that a tap does nothing. If one of
/// these ever passes because it quietly became an ordinary button again, the
/// mis-tap it exists to prevent is back — a driver sent for a box nobody
/// packed.
void main() {
  /// Mounts the control and returns a counter of how often it has confirmed.
  Future<int Function()> mount(
    WidgetTester tester, {
    TextDirection dir = TextDirection.ltr,
    bool enabled = true,
  }) async {
    var fired = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: dir,
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: 320,
                child: SwipeToConfirm(
                  label: 'Mark ready',
                  enabled: enabled,
                  onConfirmed: () => fired++,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return () => fired;
  }

  testWidgets('a tap does not confirm', (tester) async {
    final fired = await mount(tester);
    await tester.tap(find.byType(SwipeToConfirm));
    await tester.pumpAndSettle();
    expect(fired(), 0);
  });

  testWidgets('a short drag does not confirm', (tester) async {
    final fired = await mount(tester);
    await tester.drag(find.byType(SwipeToConfirm), const Offset(60, 0));
    await tester.pumpAndSettle();
    expect(fired(), 0);
  });

  testWidgets('a full drag confirms exactly once', (tester) async {
    final fired = await mount(tester);
    await tester.drag(find.byType(SwipeToConfirm), const Offset(320, 0));
    await tester.pumpAndSettle();
    expect(fired(), 1);
  });

  testWidgets('in Arabic the drag goes the other way', (tester) async {
    final fired = await mount(tester, dir: TextDirection.rtl);

    // Dragging right is the LTR gesture; in an RTL layout it must do nothing.
    await tester.drag(find.byType(SwipeToConfirm), const Offset(320, 0));
    await tester.pumpAndSettle();
    expect(fired(), 0);

    await tester.drag(find.byType(SwipeToConfirm), const Offset(-320, 0));
    await tester.pumpAndSettle();
    expect(fired(), 1);
  });

  testWidgets('disabled ignores a full drag', (tester) async {
    final fired = await mount(tester, enabled: false);
    await tester.drag(find.byType(SwipeToConfirm), const Offset(320, 0));
    await tester.pumpAndSettle();
    expect(fired(), 0);
  });
}
