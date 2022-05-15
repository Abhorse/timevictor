import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/modals/razorpayX_details.dart';
import 'package:timevictor/modals/transaction.dart';
import 'package:timevictor/modals/user_account.dart';
import 'package:timevictor/screens/payment/add_and_list_account.dart';
import 'package:timevictor/screens/payment/contact_details.dart';
import 'package:timevictor/screens/payment/debit_card_widget.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/services/razorpayX.dart';
import 'package:timevictor/utils/helper.dart';
import 'package:timevictor/widgets/circular_loader.dart';
import 'package:timevictor/widgets/platform_alert_dialog.dart';
import 'dart:convert' as convert;

class PayoutView extends StatefulWidget {
  @override
  _PayoutViewState createState() => _PayoutViewState();
}

class _PayoutViewState extends State<PayoutView> {
  bool isValidCont = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contactController = TextEditingController();

  TextEditingController _accountHolderController = TextEditingController();
  TextEditingController _ifsctController = TextEditingController();
  TextEditingController _accNumController = TextEditingController();
  TextEditingController _accNumReController = TextEditingController();

  TextEditingController _amountController = TextEditingController();

  bool isAccountProcessing = false;
  void toggleAccountLoader(bool status) {
    setState(() {
      isAccountProcessing = status;
    });
  }

  void createContact() async {
    await RazorPayX.createContact(
      name: _nameController.text,
      contact: _contactController.text,
      email: _emailController.text,
    );
  }

  bool isValidContact() {
    return _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _contactController.text.isNotEmpty;
  }

  Future<void> gotoCreateFundAcountView(BuildContext context, Database database,
      UserAccountInfo userAccountInfo) async {
    try {
      toggleAccountLoader(true);
      var map = await RazorPayX.createContact(
        name: userAccountInfo.cardHolderName,
        contact: userAccountInfo.contactNumber,
        email: userAccountInfo.eamil,
      );
      if (map != null) {
        await database.createRazorpayXData(RazorpayXPayout(
          xContactId: map['id'],
          xContactNumber: map['contact'],
        ));

        Helper.customSnackBar(
          context: context,
          color: Colors.green,
          message: "Successfully added your contact details",
        );
      } else {
        Helper.customSnackBar(
          context: context,
          color: Colors.red,
          message: "Error whiling adding your account details",
        );
      }
      toggleAccountLoader(false);
    } catch (e) {
      print(e);
      toggleAccountLoader(false);
    }
  }

  Future<void> createFundAccount(BuildContext context, Database database,
      String contactId, UserAccountInfo userAccountInfo) async {
    try {
      FocusScope.of(context).unfocus();
      toggleAccountLoader(true);
      var response = await RazorPayX.createFundAccount(
        name: userAccountInfo.cardHolderName,
        contactId: contactId,
        ifscCode: userAccountInfo.ifscCode,
        accountNumber: userAccountInfo.accountNumber,
      );
      var jsonResponse = convert.jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await database.createRazorpayXFundData(RazorpayXPayout(
          accountHolderName: userAccountInfo.cardHolderName,
          ifscCode: userAccountInfo.ifscCode,
          accountNumber: userAccountInfo.accountNumber,
          fundAccountId: jsonResponse['id'],
        ));

        Helper.customSnackBar(
          context: context,
          color: Colors.green,
          message: "Successfully added your account details",
        );
        // print(jsonResponse);
        // return jsonResponse;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        String msg = jsonResponse['error']['field'] ?? 'details';

        Helper.customSnackBar(
          context: context,
          color: Colors.red,
          message: "Failed to added your account details, $msg is incorrect.",
        );
      }

      // if (response != null) {
      //   await database.createRazorpayXFundData(RazorpayXPayout(
      //     accountHolderName: _accountHolderController.text,
      //     ifscCode: _ifsctController.text,
      //     accountNumber: _accNumController.text,
      //     fundAccountId: response['id'],
      //   ));

      //   Helper.customSnackBar(
      //     context: context,
      //     color: Colors.green,
      //     message: "Successfully added your account details",
      //   );
      // } else {
      //   Helper.customSnackBar(
      //     context: context,
      //     color: Colors.red,
      //     message:
      //         "Failed to added your account details, please check your details.",
      //   );
      // }
      toggleAccountLoader(false);
    } catch (e) {
      toggleAccountLoader(false);
      PlatformAlertDialog(
        title: 'Error',
        content: e.toString(),
        defaultActionText: 'OK',
      ).show(context);
    }
  }

  Future<void> payoutAmount(BuildContext context,
      RazorpayXPayout razorpayXPayout, Database database, String amt) async {
    int amount = int.parse(amt);
    try {
      toggleAccountLoader(true);

      var balance = await database.getWalletBalance();
      if (balance < amount) {
        toggleAccountLoader(false);
        Helper.customSnackBar(
          context: context,
          color: Colors.red,
          message: 'Insufficient wallet balance',
        );
        return;
      }

      var map = await RazorPayX.createPayoutRequest(
        fundAccountId: razorpayXPayout.fundAccountId,
        amount: amount < 250 ? amount - 4 : amount,
      );

      if (map != null) {
        await database.debitAmountFromTVWallet(amount);
        PayTransaction payTransaction = PayTransaction(
          amount: amount,
          contestName: 'Payout',
          isDebited: false,
          isSuccess: true,
          match: map['tax'].toString(),
          paymentMethod: 'Online',
          time: Timestamp.now(),
          transactionID: map['id'],
          orderId: map['fund_account_id'] + map['id'],
          signature: map['status'],
        );
        await database.addTransaction(payTransaction);

        Helper.customSnackBar(
          context: context,
          color: Colors.green,
          message: '$kRupeeSymbol $amt debited from your wallet',
        );
      } else {
        Helper.customSnackBar(
          context: context,
          color: Colors.red,
          message: 'Error in processing request',
        );

        // PlatformAlertDialog(
        //   title: 'Payout Failed',
        //   content: ' withdrown falied from your wallet',
        //   defaultActionText: 'OK',
        // ).show(context);
      }
      toggleAccountLoader(false);
    } catch (e) {
      toggleAccountLoader(false);
      Helper.customSnackBar(
        context: context,
        color: Colors.black,
        message: 'Error in processing request',
      );
    }
  }

  Widget fundAccountForm(
      BuildContext context, Database database, String contactId) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _accountHolderController,
                      keyboardType: TextInputType.name,
                      decoration:
                          InputDecoration(labelText: 'Acount Holder Name'),
                    ),
                    TextField(
                      controller: _ifsctController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: 'IFSC Code'),
                    ),
                    TextField(
                      controller: _accNumController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Account Number'),
                    ),
                    TextField(
                      controller: _accNumReController,
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(labelText: 'Confirm Account Number'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          FlatButton(
            child: Text('Next'),
            shape: kButtonShape,
            color: Colors.green,
            onPressed: () =>
                createFundAccount(context, database, contactId, null),
          )
        ],
      ),
    );
  }

  Widget filledFundForm(RazorpayXPayout razorpayXPayout, Database database) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Column(
            children: [
              PayoutCardWidget(
                accountNumber: razorpayXPayout.accountNumber,
                ifscCode: razorpayXPayout.ifscCode,
                name: razorpayXPayout.accountHolderName,
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Amount'),
                  ),
                  FlatButton(
                    shape: kButtonShape,
                    color: Colors.green,
                    child: Text('Withdrow'),
                    onPressed: () {
                      payoutAmount(context, razorpayXPayout, database, null);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getFundAccountView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Fund Account'),
        backgroundColor: kAppBackgroundColor,
      ),
      body: fundAccountForm(context, null, ''),
    );
  }

  void updateState(String value) {
    if (isValidCont != isValidContact()) {
      setState(() {
        isValidCont = isValidContact();
      });
    }
  }

  static final formKey = GlobalKey<FormState>();

  Widget contactFormWidgte(BuildContext context, Database database) {
    // return Column(
    //   children: [
    //     Padding(
    //       padding: EdgeInsets.all(20.0),
    //       child: Card(
    //         child: Padding(
    //           padding: EdgeInsets.all(20.0),
    //           child: Column(
    //             children: [
    //               TextField(
    //                 keyboardType: TextInputType.name,
    //                 controller: _nameController,
    //                 decoration: InputDecoration(labelText: 'Name'),
    //                 onChanged: updateState,
    //               ),
    //               TextField(
    //                 keyboardType: TextInputType.emailAddress,
    //                 controller: _emailController,
    //                 decoration: InputDecoration(labelText: 'Email'),
    //                 onChanged: updateState,
    //               ),
    //               TextField(
    //                 keyboardType: TextInputType.phone,
    //                 controller: _contactController,
    //                 decoration: InputDecoration(labelText: 'Contact'),
    //                 onChanged: updateState,
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //     FlatButton(
    //       shape: kButtonShape,
    //       color: Colors.green,
    //       child: Text('Next'),
    //       disabledColor: Colors.grey,
    //       onPressed: isValidCont
    //           ? () => gotoCreateFundAcountView(context, database)
    //           : null,
    //     )
    //   ],
    // );
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'First Attempt to Withdrow',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Card(
            shape: kButtonShape,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: kAppBackgroundColor,
                      keyboardType: TextInputType.name,
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter you name';
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter you email';
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _contactController,
                      decoration: InputDecoration(labelText: 'Contact'),
                      // onChanged: updateState,
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter you contact';
                        if (value.length < 10) return 'Invalid contact number';
                        return null;
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        FlatButton(
          shape: kButtonShape,
          color: kAppBackgroundColor,
          child: Text(
            'Create',
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          disabledColor: Colors.grey,
          onPressed: () {
            if (formKey.currentState.validate()) {
              print('Valid');
            } else {
              print('Invalid filedd');
            }
          },
          // onPressed: isValidContact() ? addContactDetails : null,
          // onPressed: isValidCont
          //     ? () => gotoCreateFundAcountView(context, database)
          //     : null,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Database database =
        FirestoreDatabase(uid: Provider.of<Data>(context, listen: false).uid);
    return Container(
      color: kAppBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: ModalProgressHUD(
            inAsyncCall: isAccountProcessing,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [kAppBackgroundColor, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.5, 0.5]),
              ),
              child: SingleChildScrollView(
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
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    StreamBuilder(
                      stream: database.getRazorpayXData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          RazorpayXPayout razorpayXPayout = snapshot.data;
                          if (razorpayXPayout != null &&
                              razorpayXPayout.xContactId.isNotEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Card(
                                //   child: Column(
                                //     children: [
                                //       Text('${razorpayXPayout.xContactId} '),
                                //       Text('and ${razorpayXPayout.xContactNumber}'),
                                //     ],
                                //   ),
                                // ),
                                // razorpayXPayout.fundAccountId.isEmpty
                                //     ? fundAccountForm(context, database,
                                //         razorpayXPayout.xContactId)
                                //     : filledFundForm(razorpayXPayout, database),
                                // // contactFormWidgte(context, database),
                                ListAndAddFundAccount(
                                  razorpayXPayout: razorpayXPayout,
                                  addFundAccount:
                                      (UserAccountInfo userAccountInfo) {
                                    createFundAccount(
                                      context,
                                      database,
                                      razorpayXPayout.xContactId,
                                      userAccountInfo,
                                    );
                                  },
                                  payout: (amount) {
                                    payoutAmount(context, razorpayXPayout,
                                        database, amount);
                                  },
                                )
                              ],
                            );
                          } else
                            return ContactForm(
                              addContact: (context, name, email, number) async {
                                print('$name $email, $number');
                                await gotoCreateFundAcountView(
                                  context,
                                  database,
                                  UserAccountInfo(
                                      cardHolderName: name,
                                      eamil: email,
                                      contactNumber: number),
                                );
                              },
                              formKey: formKey,
                              isLoading: false,
                            );
                        } else
                          return CircularLoader();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
