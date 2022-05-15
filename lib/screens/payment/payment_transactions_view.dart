import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/modals/transaction.dart';
import 'package:timevictor/screens/payment/add_account_details.dart';
import 'package:timevictor/screens/payment/debit_card_widget.dart';
import 'package:timevictor/screens/payment/payout_view.dart';
import 'package:timevictor/screens/payment/transaction_card_widget.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/utils/dateTime_formater.dart';
import 'package:timevictor/widgets/circular_loader.dart';
import 'package:timevictor/widgets/platform_alert_dialog.dart';
import 'package:timevictor/widgets/wallet_balance.dart';

class PaymentTransactions extends StatefulWidget {
  @override
  _PaymentTransactionsState createState() => _PaymentTransactionsState();
}

class _PaymentTransactionsState extends State<PaymentTransactions> {
  List<Widget> getTransactionsCard(List<PayTransaction> transactions) =>
      transactions
          .map((transaction) => TransactionCardWidget(transaction: transaction))
          .toList();

  Widget transactionStreamBuilder(BuildContext context) {
    return StreamBuilder(
      stream:
          FirestoreDatabase(uid: Provider.of<Data>(context, listen: false).uid)
              .getAllPaymentTransactions(),
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.active) {
          //do something
          List<PayTransaction> payHistory = snapshots.data;
          if (payHistory == null || payHistory.length == 0) {
            return Expanded(
              child: Center(
                child: Text(
                  'No transaction history',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else
            return Expanded(
              child: ListView(
                children: getTransactionsCard(payHistory),
              ),
            );
        } else
          return CircularLoader();
      },
    );
  }

  Widget oldScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions History'),
        backgroundColor: kAppBackgroundColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Balance',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    WalletBalanceWidget(),
                    FlatButton(
                      shape: kButtonShape,
                      color: kAppBackgroundColor,
                      child: Text(
                        '  Withdraw  ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        // PlatformAlertDialog(
                        //   title: 'Not Available',
                        //   content: 'Keep Calm And Say Jai Shree Ram!!!   Please update your app to use this feature.',
                        //   defaultActionText: 'OK',
                        // ).show(context);
                        PayoutView();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PayoutView(),
                          ),
                        );
                      },
                    )
                    // Text(
                    //   '0 $kRupeeSymbol',
                    //   style: TextStyle(
                    //     color: kAppBackgroundColor,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 20.0,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Your Transactions',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          transactionStreamBuilder(context),
        ],
      ),
    );
  }

  Widget newUIBuild(BuildContext context) {
    return Container(
      color: kAppBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      kAppBackgroundColor,
                      Colors.white,
                      Colors.white,
                      kAppBackgroundColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0.25,
                      0.25,
                      0.85,
                      0.25,
                    ])),
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
                      'Wallet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.autorenew,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                  ],
                ),
                SizedBox(
                  // width: 300.0,
                  height: 150.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Card(
                      elevation: 40,
                      shape: kButtonShape,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Center(
                            child: Text(
                              'Total Balance',
                              style: TextStyle(
                                letterSpacing: 2.0,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Center(
                            child: WalletBalanceWidget(
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: kAppBackgroundColor,
                              ),
                            ),
                          ),
                          Center(
                            child: FlatButton(
                              shape: kCardShape(5.0),
                              color: kAppBackgroundColor,
                              child: Text(
                                '  Withdraw  ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              onPressed: () {
                                // AddAccountDetailsWidget().show(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PayoutView(),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   width: 400.0,
                //   height: 200.0,
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     children: [
                //       PayoutCardWidget(),
                //       PayoutCardWidget(),
                //     ],
                //   ),
                // ),
                //TODO: Add Filters here
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 20.0),
                //   child: SizedBox(
                //     height: 70.0,
                //     child: Card(
                //       color: Colors.grey[200],
                //       shape: kButtonShape,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           Container(
                //             width: 160,
                //             height: 50.0,
                //             decoration: BoxDecoration(
                //               color: Colors.grey,
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(15.0)),
                //             ),
                //             child: Center(
                //                 child: Text(
                //               'Debited',
                //               style: TextStyle(
                //                 fontSize: 20.0,
                //                 fontWeight: FontWeight.bold,
                //                 color: kAppBackgroundColor,
                //               ),
                //             )),
                //           ),
                //           Container(
                //             color: Colors.grey[200],
                //             width: 150,
                //             child: Center(child: Text('Credited')),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Text(
                    'Transaction History',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                transactionStreamBuilder(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return oldScreen(context);
    return newUIBuild(context);
  }
}
