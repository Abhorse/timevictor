import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/alert_messages.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/modals/payment.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/widgets/circular_loader.dart';
import 'package:timevictor/widgets/platform_alert_dialog.dart';
import 'package:timevictor/widgets/wallet_balance.dart';

class PaymentModal extends StatelessWidget {
  PaymentModal({
    @required this.joiningAmount,
    @required this.context,
    @required this.payFromWallet,
    @required this.payOnline,
    @required this.joinFree,
  })  : assert(joiningAmount != null),
        assert(payFromWallet != null),
        assert(context != null),
        assert(payOnline != null);

  final int joiningAmount;
  final BuildContext context;
  final Function payOnline;
  final Function payFromWallet;
  final Function joinFree;

  Future<bool> show(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => this,
    );
  }

  void payOnlineHandler(BuildContext context, int amount) {
    Navigator.pop(context);
    payOnline(amount);
  }

  void payFromWalletHandler(BuildContext context, int amount) {
    Navigator.pop(context);
    payFromWallet(amount);
  }

  void payFree(BuildContext context) {
    Navigator.pop(context);
    joinFree();
  }

  Row getCustomRow(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key),
        Text('$value $kRupeeSymbol'),
      ],
    );
  }

  Future<int> getApplicableCashBonus() async {
    int cashBonus = 0;
    try {
      final Database database =
          FirestoreDatabase(uid: Provider.of<Data>(context, listen: false).uid);
      var bonusWallet = await database.getCashBonusBalance();
      cashBonus = bonusWallet.toInt();
    } catch (e) {
      print(e);
    }

    return cashBonus;
  }

  int getValidBonus(int bonusBalance) {
    if (bonusBalance >= joiningAmount ~/ 2) {
      return joiningAmount ~/ 2;
    } else {
      return bonusBalance;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          color: Color(0xff757575),
          child: StreamBuilder<bool>(
              stream: null,
              builder: (context, snapshot) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: FutureBuilder<int>(
                        future: getApplicableCashBonus(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            int cashBonus = snapshot.data;
                            int usableCashBonus = getValidBonus(cashBonus);
                            int amountToPay = joiningAmount - usableCashBonus;
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Paymet Details',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                                Divider(thickness: 1.0),
                                SizedBox(height: 10.0),
                                getCustomRow(
                                    'Joining Amount', '$joiningAmount'),
                                SizedBox(height: 5.0),
                                // getCustomRow(
                                //   'Usable Cash Bonus',
                                //   '- $usableCashBonus',
                                // ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.gift,
                                          color: Colors.redAccent,
                                          size: 20.0,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text('Usable Cash Bonus'),
                                        // SizedBox(width: 5.0),
                                        // Icon(
                                        //   FontAwesomeIcons.gift,
                                        //   color: Colors.red,
                                        //   size: 18.0,
                                        // ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.info,
                                            color: kAppBackgroundColor,
                                            size: 18.0,
                                          ),
                                          onPressed: () {
                                            PlatformAlertDialog(
                                              title: 'Cash Bonus',
                                              content: kCashBonusInfoMsg,
                                              defaultActionText: 'ok',
                                            ).show(context);
                                          },
                                        ),
                                      ],
                                    ),
                                    Text('- $usableCashBonus $kRupeeSymbol'),
                                  ],
                                ),
                                // FutureBuilder<int>(
                                //   future: getApplicableCashBonus(),
                                //   builder: (context, snapshot) {
                                //     return getCustomRow(
                                //         'Usable Cash Bonus',
                                //         (snapshot.connectionState ==
                                //                 ConnectionState.done)
                                //             ? '- ${getValidBonus(snapshot.data ?? 0)}'
                                //             : 'Loading...');
                                //   },
                                // ),
                                SizedBox(height: 5.0),
                                getCustomRow('Discount (any)', '- 0'),
                                Divider(
                                  color: Colors.black,
                                  height: 15.0,
                                  thickness: 1.0,
                                ),
                                getCustomRow('Amount to Pay', '$amountToPay'),
                                SizedBox(height: 10.0),
                                // Divider(thickness: 1.0),
                                Visibility(
                                  visible: joiningAmount <= 0,
                                  child: Center(
                                    child: FlatButton(
                                      color: kAppBackgroundColor,
                                      shape: kButtonShape,
                                      child: Text(
                                        'Join Free',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: joiningAmount > 0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Paymet Methods',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Divider(thickness: 1.0),
                                      // SizedBox(height: 20.0),
                                      StreamBuilder<WalletBalance>(
                                        stream: FirestoreDatabase(
                                                uid: Provider.of<Data>(context)
                                                    .uid)
                                            .getCurrentWalletBalance(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.active) {
                                            WalletBalance walletBalance =
                                                snapshot.data;
                                            if (walletBalance != null) {
                                              // return
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Wallet ( $kRupeeSymbol ${walletBalance.walletBalance} )',
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  FlatButton(
                                                    disabledColor:
                                                        Colors.grey[300],
                                                    color: kAppBackgroundColor,
                                                    child: Text(
                                                      'Pay',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    onPressed: walletBalance
                                                                .walletBalance >=
                                                            amountToPay
                                                        ? () =>
                                                            payFromWalletHandler(
                                                                context,
                                                                amountToPay)
                                                        : null,
                                                    shape: kButtonShape,
                                                  )
                                                ],
                                              );
                                            } else
                                              return Center(
                                                child: Text(
                                                    'Not able to process wallet'),
                                              );
                                          } else
                                            return CircularLoader();
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Online',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          FlatButton(
                                            color: kAppBackgroundColor,
                                            child: Text(
                                              'Pay',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () => payOnlineHandler(
                                                context, amountToPay),
                                            shape: kButtonShape,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Row(
                                //       children: [
                                //         Text(
                                //           'Wallet (',
                                //           style: TextStyle(
                                //             fontSize: 18.0,
                                //             fontWeight: FontWeight.w500,
                                //           ),
                                //         ),
                                //         WalletBalanceWidget(),
                                //         Text(
                                //           ')',
                                //           style: TextStyle(
                                //             fontSize: 18.0,
                                //             fontWeight: FontWeight.w500,
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //     FlatButton(
                                //       color: kAppBackgroundColor,
                                //       child: Text(
                                //         'Pay',
                                //         style: TextStyle(
                                //           color: Colors.white,
                                //         ),
                                //       ),
                                //       onPressed: () => payFromWalletHandler(context),
                                //       shape: kButtonShape,
                                //     )
                                //   ],
                                // ),
                              ],
                            );
                          } else
                            return CircularLoader();
                        }),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
