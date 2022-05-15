import 'package:flutter/material.dart';
import 'package:timevictor/constants.dart';

class AddFundAccountForm extends StatefulWidget {
  @override
  _AddFundAccountFormState createState() => _AddFundAccountFormState();
}

class _AddFundAccountFormState extends State<AddFundAccountForm> {
  TextEditingController _accountHolderController = TextEditingController();
  TextEditingController _ifsctController = TextEditingController();
  TextEditingController _accNumController = TextEditingController();
  TextEditingController _accNumReController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
            // onPressed: () => createFundAccount(context, database, contactId),
          )
        ],
      ),
    );
  }
}
