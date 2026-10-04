/// `refund_bank_details` on a partner order — present only while Santra is
/// waiting for the account to refund a shop-entered order into. The IBAN is
/// never sent back, by design.
class RefundBankDetails {
  final bool needed;
  final num amount;

  const RefundBankDetails({required this.needed, required this.amount});

  factory RefundBankDetails.fromJson(Map<String, dynamic> json) =>
      RefundBankDetails(
        needed: json['needed'] == true || json['needed'].toString() == '1',
        amount: num.tryParse(json['amount'].toString()) ?? 0,
      );
}
