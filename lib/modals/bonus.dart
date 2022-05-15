class BonusWallet {
  final double bonusBalance;

  BonusWallet({
    this.bonusBalance,
  });

  factory BonusWallet.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final double bonusBalance = data['bonusBalance'] ?? 0;

    return BonusWallet(
      bonusBalance: bonusBalance,
    );
  }
}
