import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../app/app.locator.dart';
import '../../models/cancel_reason.dart';
import '../../models/failure.dart';
import '../../models/order.dart';
import '../../services/orders_service.dart';
import '../common/app_colors.dart';
import 'app_icon.dart';
import 'app_text.dart';
import 'app_text_field.dart';
import 'primary_button.dart';

/// Our own words for the cancel errors the partner API documents; anything
/// else falls back to the server's message.
String cancelErrorCopy(Failure f) => switch (f.code) {
      'CANCEL_REASON_REQUIRED' => 'cancel_reason_label'.tr(),
      'NOTE_REQUIRED' => 'cancel_note_label'.tr(),
      'NOT_YOURS_TO_MAKE' => 'contact_santra'.tr(),
      _ => f.message,
    };

/// What the partner chose in [showCancelOrderSheet].
typedef CancelChoice = ({String reasonCode, String note, String? courierStage});

/// Confirmation before cancelling: the reason list comes from the server
/// (`GET /orders/cancel-reasons`, EN + AR, and a different six for a parcel),
/// so labels can change without an app release. Null when the partner backs out.
Future<CancelChoice?> showCancelOrderSheet(
  BuildContext context, {
  required Order order,
  String? courierStage,
}) {
  return showModalBottomSheet<CancelChoice>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x80143232),
    isScrollControlled: true,
    builder: (context) => _CancelOrderSheet(
      order: order,
      courierStage: courierStage ?? order.courierStage,
    ),
  );
}

/// Runs the cancel sheet, sending what the partner picked through [send].
///
/// If the courier moved on while the sheet was open the API answers
/// `COURIER_STAGE_CHANGED`; the sheet is redrawn with the stage it returns and
/// the partner is asked again, as the backend spec requires.
Future<void> runCancelFlow(
  BuildContext context,
  Order order,
  Future<Failure?> Function(CancelChoice) send,
) async {
  var stage = order.courierStage;
  while (true) {
    final choice =
        await showCancelOrderSheet(context, order: order, courierStage: stage);
    if (choice == null) return;
    final failure = await send(choice);
    if (failure?.code != 'COURIER_STAGE_CHANGED') return;
    stage = failure?.details?['courierStage']?.toString() ?? stage;
    if (!context.mounted) return;
  }
}

class _CancelOrderSheet extends StatefulWidget {
  const _CancelOrderSheet({required this.order, this.courierStage});

  final Order order;
  final String? courierStage;

  @override
  State<_CancelOrderSheet> createState() => _CancelOrderSheetState();
}

class _CancelOrderSheetState extends State<_CancelOrderSheet> {
  final _ordersService = locator<OrdersService>();
  final _noteController = TextEditingController();

  List<CancelReason> _reasons = const [];
  CancelReason? _picked;
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    final result = await _ordersService.fetchCancelReasons(
        kind: widget.order.isParcel ? 'delivery_service' : null);
    if (!mounted) return;
    result.fold(
      (_) => setState(() {
        _loading = false;
        _failed = true;
      }),
      (reasons) => setState(() {
        _reasons = reasons;
        _loading = false;
      }),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  /// "Another reason" says nothing on its own, so it carries the note.
  bool get _canSubmit =>
      _picked != null &&
      (!_picked!.needsComment || _noteController.text.trim().isNotEmpty);

  void _submit() => Navigator.of(context).pop((
        reasonCode: _picked!.code,
        note: _noteController.text.trim(),
        courierStage: widget.courierStage,
      ));

  /// What cancelling costs at this point in the courier's journey.
  String? get _stageLine => switch (widget.courierStage) {
        'before_assignment' => 'stage_before_assignment'.tr(),
        'after_assignment' => 'stage_after_assignment'.tr(),
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82),
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
        decoration: const BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                    color: AppColors.lineStrong,
                    borderRadius: BorderRadius.circular(999))),
            const SizedBox(height: 18),
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                  color: AppColors.dangerBg,
                  borderRadius: BorderRadius.circular(18)),
              child: const Center(
                  child: AppIcon('x', size: 28, color: AppColors.danger)),
            ),
            const SizedBox(height: 14),
            AppText.display('confirm_reject'.tr(),
                fontSize: 24, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            AppText.body('confirm_reject_sub'.tr(),
                color: AppColors.muted,
                fontSize: 15,
                textAlign: TextAlign.center),
            if (_stageLine != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.brandSofter,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  children: [
                    const AppIcon('truck', size: 17, color: AppColors.brand),
                    const SizedBox(width: 9),
                    Expanded(
                      child: AppText(_stageLine!,
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 18),
            Flexible(child: _body(lang)),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'keep_order'.tr(),
                    variant: ButtonVariant.ghost,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'reject_order'.tr(),
                    variant: ButtonVariant.danger,
                    disabled: !_canSubmit,
                    onPressed: _canSubmit ? _submit : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(String lang) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(child: CircularProgressIndicator(color: AppColors.brand)),
      );
    }
    if (_failed) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.body('reasons_failed'.tr(),
              color: AppColors.muted,
              fontSize: 15,
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          PrimaryButton(
              label: 'retry'.tr(),
              variant: ButtonVariant.ghost,
              onPressed: _load),
        ],
      );
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.label('cancel_reason_label'.tr()),
          const SizedBox(height: 10),
          for (final r in _reasons) ...[
            _ReasonTile(
              label: r.label(lang),
              selected: r.code == _picked?.code,
              onTap: () => setState(() => _picked = r),
            ),
            const SizedBox(height: 8),
          ],
          if (_picked?.needsComment ?? false) ...[
            const SizedBox(height: 6),
            AppTextField(
              controller: _noteController,
              label: 'cancel_note_label'.tr(),
              hintText: 'cancel_note_hint'.tr(),
              maxLength: 500,
              onChanged: (_) => setState(() {}),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReasonTile extends StatelessWidget {
  const _ReasonTile(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandSofter : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.brand : AppColors.line,
            width: selected ? 1.8 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.brand : Colors.transparent,
                border: Border.all(
                    color: selected ? AppColors.brand : AppColors.lineStrong,
                    width: 1.8),
              ),
              child: selected
                  ? const Center(
                      child: AppIcon('check', size: 12, color: Colors.white))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
                child:
                    AppText(label, fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
