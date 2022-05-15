class RazorpayXPayout {
  final String xContactId;
  final String xContactNumber;
  final String accountHolderName;
  final String ifscCode;
  final String accountNumber;
  final String fundAccountId;

  RazorpayXPayout({
    this.xContactId,
    this.xContactNumber,
    this.accountHolderName,
    this.accountNumber,
    this.fundAccountId,
    this.ifscCode,
  });

  factory RazorpayXPayout.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final String xContactId = data['xContactId'] ?? '';
    final String xContactNumber = data['xContactNumber'] ?? '';
    final String accountHolderName = data['accountHolderName'] ?? '';
    final String fundAccountId = data['fundAccountId'] ?? '';
    final String ifscCode = data['ifscCode'] ?? '';
    final String accountNumber = data['accountNumber'] ?? '';

    return RazorpayXPayout(
      xContactId: xContactId,
      xContactNumber: xContactNumber,
      accountHolderName: accountHolderName,
      fundAccountId: fundAccountId,
      ifscCode: ifscCode,
      accountNumber: accountNumber,
    );
  }

  Map<String, dynamic> toMap() => {
        "xContactId": this.xContactId,
        "xContactNumber": this.xContactNumber,
      };

  Map<String, dynamic> toMapFundAccountData() => {
        "fundAccountId": this.fundAccountId,
        "accountHolderName": this.accountHolderName,
        "ifscCode": this.ifscCode,
        "accountNumber": this.accountNumber,
      };
}
