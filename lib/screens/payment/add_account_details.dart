import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/modals/razorpayX_details.dart';
import 'package:timevictor/screens/payment/add_and_list_account.dart';
import 'package:timevictor/screens/payment/contact_details.dart';
import 'package:timevictor/screens/payment/debit_card_widget.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/services/razorpayX.dart';
import 'package:timevictor/widgets/circular_loader.dart';

class AddAccountDetailsWidget extends StatelessWidget {
  Future<bool> show(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => this,
    );
  }

  Future<void> addContactDetails(
    BuildContext context,
    String name,
    String email,
    String number,
  ) async {
    var map = await RazorPayX.createContact(
      name: name,
      contact: email,
      email: number,
    );
    if (map != null) {
      await FirestoreDatabase(
              uid: Provider.of<Data>(context, listen: false).uid)
          .createRazorpayXData(RazorpayXPayout(
        xContactId: map['id'],
        xContactNumber: map['contact'],
      ));
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => getFundAccountView(context),
      //   ),
      // );
    }
    print('$name $email $number');
  }

  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print('Re-building add account details page');
    // bool isListAccount = false;
    return SingleChildScrollView(
        child: Container(
      // padding:
      // EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        color: Color(0xff757575),
        child: StreamBuilder<bool>(
          stream: null,
          builder: (context, snapshot) {
            return Container(
              // height: 200.0,
              decoration: BoxDecoration(
                  color: kAppBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                  ),
                  gradient: LinearGradient(
                    colors: [kAppBackgroundColor, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.5, 0.5],
                  )),
              child: Column(
                children: [
                  StreamBuilder(
                    stream: FirestoreDatabase(
                            uid: Provider.of<Data>(context, listen: false).uid)
                        .getRazorpayXData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        RazorpayXPayout razorpayXPayout = snapshot.data;
                        if (razorpayXPayout != null &&
                            razorpayXPayout.xContactId.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Card(
                              //   child: Column(
                              //     children: [
                              //       Text('${razorpayXPayout.xContactId} '),
                              //       Text(
                              //           'and ${razorpayXPayout.xContactNumber}'),
                              //     ],
                              //   ),
                              // ),
                              Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Your Account Details',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     CircleAvatar(
                              //       radius: 30.0,
                              //       backgroundColor: isListAccount
                              //           ? Colors.white
                              //           : kAppBackgroundColor,
                              //       child: IconButton(
                              //         icon: Icon(
                              //           Icons.account_balance,
                              //           size: 40.0,
                              //           color: isListAccount
                              //               ? kAppBackgroundColor
                              //               : Colors.white,
                              //         ),
                              //         onPressed: () {
                              //           isListAccount = true;
                              //         },
                              //       ),
                              //     ),
                              //     CircleAvatar(
                              //       radius: 30.0,
                              //       backgroundColor: isListAccount
                              //           ? kAppBackgroundColor
                              //           : Colors.white,
                              //       child: IconButton(
                              //         icon: Icon(
                              //           Icons.playlist_add,
                              //           size: 40.0,
                              //           color: isListAccount
                              //               ? Colors.white
                              //               : kAppBackgroundColor,
                              //         ),
                              //         onPressed: () {
                              //           isListAccount = false;
                              //         },
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // razorpayXPayout.fundAccountId.isEmpty
                              //     ? Text('Add Account Details')
                              //     : PayoutCardWidget(
                              //         name: razorpayXPayout.accountHolderName,
                              //         accountNumber:
                              //             razorpayXPayout.accountNumber,
                              //         ifscCode: razorpayXPayout.ifscCode,
                              //       ),
                              //TODO: uncommnent this this code
                              ListAndAddFundAccount(
                                razorpayXPayout: razorpayXPayout,
                              ),

                              // TextField()

                              // Padding(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 100.0, vertical: 20.0),
                              //   child: FlatButton(
                              //     shape: kButtonShape,
                              //     color: kAppBackgroundColor,
                              //     child: Text(
                              //       'Withdraw',
                              //       style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //           fontSize: 20.0,
                              //           color: Colors.white),
                              //     ),
                              //     onPressed: () {},
                              //   ),
                              // )
                            ],
                          );
                        } else
                          return Container();
                        // return ContactForm(
                        //   addContact: addContactDetails,
                        // );
                      } else
                        return CircularLoader();
                    },
                  ),
                  // ContactForm(
                  //   addContact: addContactDetails,
                  //   formKey: formKey,
                  //   isLoading: false,
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    ));
  }
}
