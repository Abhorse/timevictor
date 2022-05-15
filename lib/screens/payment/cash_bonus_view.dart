import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/modals/bonus.dart';
import 'package:timevictor/modals/bonus_transaction.dart';
import 'package:timevictor/modals/transaction.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/utils/dateTime_formater.dart';
import 'package:timevictor/utils/helper.dart';
import 'package:timevictor/widgets/circular_loader.dart';

class CashBonusPage extends StatelessWidget {
  List<Widget> getBonusWalletTransactions(
      List<BonusTransaction> bonusTransactions) {
    return bonusTransactions
        .map(
          (e) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Card(
              child: ExpansionTile(
                title: newCard(e),
                children: [
                  keyValuePair(
                      'Date', FormattedDateTime.paymentFormat(e.date), false),
                  keyValuePair(
                      'Remark',
                      e.isCredited
                          ? 'For referring ${e.by}'
                          : 'Joined a contest for match ${e.by}',
                      true)
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  Widget keyValuePair(String key, String value, bool showBorder) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 5.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              key,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
                decoration: showBorder
                    ? BoxDecoration(
                        border: Border.all(
                          color: kAppBackgroundColor,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      )
                    : null,
                width: 150.0,
                child: Padding(
                  padding: EdgeInsets.all(showBorder ? 10.0 : 0.0),
                  child: Text(
                    value,
                  ),
                )),
          ],
        ),
      );

  Widget newCard(BonusTransaction transaction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.green,
                child: Icon(
                  transaction.isCredited
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.isCredited ? 'Referral Bonus' : 'Joined Contest',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Success',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          children: [
            Text(
              '$kRupeeSymbol ${transaction.bonusAmonut}',
              style: TextStyle(
                fontSize: 20.0,
                color: kAppBackgroundColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kAppBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [kAppBackgroundColor, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.5, 0.5])),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Cash Bonus',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.sync,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        build(context);
                      },
                    ),
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: Card(
                    elevation: 10.0,
                    shadowColor: Colors.grey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 25.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.gift,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                'Current Balance',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          StreamBuilder<BonusWallet>(
                            stream: FirestoreDatabase(
                                    uid: Provider.of<Data>(context, listen: false).uid)
                                .getBonusWalletBalance(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                BonusWallet bonusWallet = snapshot.data;
                                int bonus = bonusWallet != null
                                    ? bonusWallet.bonusBalance.toInt()
                                    : 0;
                                return Text(
                                  '$kRupeeSymbol $bonus',
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              } else
                                return CircularLoader();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Row(
                    children: [
                      Text(
                        'Referral and Transactions History ',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<List<BonusTransaction>>(
                  stream: FirestoreDatabase(uid: Provider.of<Data>(context, listen: false).uid)
                      .getBonusTransactions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      List<BonusTransaction> bonusTransaction = snapshot.data;
                      if (bonusTransaction != null &&
                          bonusTransaction.length != 0) {
                        return Expanded(
                          child: ListView(
                            children:
                                getBonusWalletTransactions(bonusTransaction),
                          ),
                        );
                      }
                      return Expanded(
                        child: Center(
                          child: Text(
                            'No transactions found',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    } else
                      return CircularLoader();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
