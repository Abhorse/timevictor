import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/modals/payment.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/widgets/circular_loader.dart';

class WalletBalanceWidget extends StatelessWidget {
  const WalletBalanceWidget({Key key, this.style}) : super(key: key);

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<WalletBalance>(
      stream: FirestoreDatabase(uid: Provider.of<Data>(context).uid)
          .getCurrentWalletBalance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          //do something
          WalletBalance walletBalance = snapshot.data;
          if (walletBalance != null) {
            return Text(' $kRupeeSymbol ${walletBalance.walletBalance}',
                style: style ??
                    TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: kAppBackgroundColor,
                    ));
          } else
            return Text('NA');
        } else
          return Center(child: CircularLoader());
      },
    );
  }
}
