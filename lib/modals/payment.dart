class WalletBalance {
  WalletBalance({
    this.walletBalance,
  });
  final int walletBalance;

  factory WalletBalance.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final int walletBalance = data['walletBalance'] ?? 0;

    return WalletBalance(
      walletBalance: walletBalance,
    );
  }
  Map<String, dynamic> toMap() => {
        'walletBalance': walletBalance,
      };
}
