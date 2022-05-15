import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timevictor/modals/razorpayX_details.dart';
import 'package:timevictor/modals/user_account.dart';
import 'package:timevictor/screens/payment/add_fund_account_form.dart';
import 'package:timevictor/screens/payment/debit_card_widget.dart';
import 'package:timevictor/widgets/Custom_SnackBar.dart';

import '../../constants.dart';

class ListAndAddFundAccount extends StatefulWidget {
  final RazorpayXPayout razorpayXPayout;
  final Function payout;
  final Function addFundAccount;

  const ListAndAddFundAccount({
    Key key,
    this.razorpayXPayout,
    this.addFundAccount,
    this.payout,
  }) : super(key: key);

  @override
  _ListAndAddFundAccountState createState() => _ListAndAddFundAccountState();
}

class _ListAndAddFundAccountState extends State<ListAndAddFundAccount> {
  bool isListAccount = true;
  bool isProcessing = false;

  TextEditingController _accountHolderController = TextEditingController();
  TextEditingController _ifsctController = TextEditingController();
  TextEditingController _accNumController = TextEditingController();
  TextEditingController _accNumReController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  final _accountformKey = GlobalKey<FormState>();
  final _amountFormKey = GlobalKey<FormState>();

  void toggleLoading(bool status) {
    setState(() => isProcessing = status);
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  Widget getPayoutAndAllAccountCards() {
    if (widget.razorpayXPayout.fundAccountId != null &&
        widget.razorpayXPayout.fundAccountId.isNotEmpty) {
      return Column(
        children: [
          // SizedBox(
          //   height: 250.0,
          //   child: ListView(
          //     scrollDirection: Axis.horizontal,
          //     children: [
          //       PayoutCardWidget(
          //         name: widget.razorpayXPayout.accountHolderName,
          //         accountNumber: widget.razorpayXPayout.accountNumber,
          //         ifscCode: widget.razorpayXPayout.ifscCode,
          //       ),

          //     ],
          //   ),
          // ),
          PayoutCardWidget(
            name: widget.razorpayXPayout.accountHolderName,
            accountNumber: widget.razorpayXPayout.accountNumber,
            ifscCode: widget.razorpayXPayout.ifscCode,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Text(
              'Note: Withdrawing less than $kRupeeSymbol 250 will charge you transaction fee $kRupeeSymbol 4',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          Form(
            key: _amountFormKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _amountController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kAppBackgroundColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter Amount ( $kRupeeSymbol )',
                      labelStyle: TextStyle(
                        color: kAppBackgroundColor,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      // hintText: '250',
                    ),
                    validator: (value) {
                      if (value.isEmpty) return 'Please Enter Amount';
                      if (!isNumeric(value)) return 'Invalid Value';
                      if (int.parse(value) < 5)
                        return "Minimum limit $kRupeeSymbol 5";
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
            shape: kButtonShape,
            color: kAppBackgroundColor,
            disabledColor: Colors.grey,
            child: Text(
              '   Withdraw   ',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              if (_amountFormKey.currentState.validate()) {
                await widget.payout(_amountController.text);
              }
              // else {
              // final snackbar = SnackBar(
              //   backgroundColor: Colors.red,
              //   content: Text('Error'),
              //   behavior: SnackBarBehavior.floating,
              //   shape: kButtonShape,
              // );

              // Scaffold.of(context).showSnackBar(snackbar);
              // }
            },
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 70.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text(
                  'You don\'t have any account added, Please first add an account.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: FlatButton(
                child: Text(
                  '  Add Account  ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500),
                ),
                shape: kButtonShape,
                color: kAppBackgroundColor,
                onPressed: () {
                  setState(() {
                    isListAccount = false;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
  }

  List<Widget> toggleListAndAddAccount() {
    return [
      // Column(
      //   children: [
      //     PayoutCardWidget(
      //       name: widget.razorpayXPayout.accountHolderName,
      //       accountNumber: widget.razorpayXPayout.accountNumber,
      //       ifscCode: widget.razorpayXPayout.ifscCode,
      //     ),
      //     Form(
      //       key: _amountFormKey,
      //       child: Column(
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.all(20.0),
      //             child: TextFormField(
      //               controller: _amountController,
      //               textAlign: TextAlign.center,
      //               style: TextStyle(
      //                 color: kAppBackgroundColor,
      //                 fontSize: 20.0,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //               keyboardType: TextInputType.number,
      //               decoration: InputDecoration(
      //                 labelText: 'Enter Amount',
      //                 labelStyle: TextStyle(
      //                   color: Colors.white,
      //                 ),
      //                 focusedBorder: UnderlineInputBorder(
      //                   borderSide: BorderSide(
      //                     color: Colors.white,
      //                     width: 2.0,
      //                   ),
      //                 ),
      //                 // hintText: '250',
      //               ),
      //               validator: (value) {
      //                 if (value.isEmpty) return 'Please Enter Amount';
      //                 if (!isNumeric(value)) return 'Invalid Value';
      //                 return null;
      //               },
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     FlatButton(
      //       shape: kButtonShape,
      //       color: kAppBackgroundColor,
      //       disabledColor: Colors.grey,
      //       child: Text(
      //         'Withdraw',
      //         style: TextStyle(
      //           fontSize: 20.0,
      //           fontWeight: FontWeight.bold,
      //           color: Colors.white,
      //         ),
      //       ),
      //       onPressed: () async {
      //         if (_amountFormKey.currentState.validate()) {
      //           await widget.payout(_amountController.text);
      //         }
      //         // else {
      //         // final snackbar = SnackBar(
      //         //   backgroundColor: Colors.red,
      //         //   content: Text('Error'),
      //         //   behavior: SnackBarBehavior.floating,
      //         //   shape: kButtonShape,
      //         // );

      //         // Scaffold.of(context).showSnackBar(snackbar);
      //         // }
      //       },
      //     ),
      //   ],
      // ),
      getPayoutAndAllAccountCards(),
      fundAccountForm()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundColor:
                  isListAccount ? Colors.white : kAppBackgroundColor,
              child: IconButton(
                icon: Icon(
                  Icons.account_balance,
                  size: 30.0,
                  color: isListAccount ? kAppBackgroundColor : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isListAccount = true;
                  });
                },
              ),
            ),
            CircleAvatar(
              radius: 30.0,
              backgroundColor:
                  isListAccount ? kAppBackgroundColor : Colors.white,
              child: IconButton(
                icon: Icon(
                  Icons.playlist_add,
                  size: 30.0,
                  color: isListAccount ? Colors.white : kAppBackgroundColor,
                ),
                onPressed: () {
                  setState(() {
                    isListAccount = false;
                  });
                },
              ),
            ),
          ],
        ),
        // widget.razorpayXPayout.fundAccountId.isEmpty
        //     ? Text('Add Account Details')
        //     : PayoutCardWidget(
        //         name: widget.razorpayXPayout.accountHolderName,
        //         accountNumber: widget.razorpayXPayout.accountNumber,
        //         ifscCode: widget.razorpayXPayout.ifscCode,
        //       ),

        toggleListAndAddAccount()[isListAccount ? 0 : 1],
        // fundAccountForm(),
      ],
    );
  }

  Widget fundAccountForm() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Card(
              shape: kButtonShape,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: _accountformKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _accountHolderController,
                        keyboardType: TextInputType.name,
                        decoration:
                            InputDecoration(labelText: 'Acount Holder Name'),
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter account haolder name';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _ifsctController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'IFSC Code'),
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter IFSC Code';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _accNumController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'Account Number'),
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter Account Number';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _accNumReController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Confirm Account Number'),
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please re-enter account number';
                          if (value != _accNumController.text)
                            return "Not Matched";
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          FlatButton(
            child: Text(
              '  Add Account  ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            shape: kButtonShape,
            color: kAppBackgroundColor,
            onPressed: () async {
              if (_accountformKey.currentState.validate()) {
                print('Valid account details');
                // toggleLoading(true);
                await widget.addFundAccount(UserAccountInfo(
                  cardHolderName: _accountHolderController.text,
                  ifscCode: _ifsctController.text,
                  accountNumber: _accNumController.text,
                ));
                // print('Valid account details');
                // toggleLoading(false);
              } else {
                print('Invalid account details');
              }
            },
            // onPressed: () => createFundAccount(context, database, contactId),
          )
        ],
      ),
    );
  }
}
