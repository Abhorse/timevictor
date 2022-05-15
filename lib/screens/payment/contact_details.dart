import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/widgets/platform_alert_dialog.dart';

class ContactForm extends StatelessWidget {
  final Function addContact;
  final GlobalKey<FormState> formKey;
  final bool isLoading;

  const ContactForm({
    Key key,
    this.addContact,
    this.formKey,
    this.isLoading,
  }) : super(key: key);
  // bool isLoading = false;

  // void toggleLoading(bool status) {
  //   setState(() => isLoading = status);
  // }

  // void updateState(String value) {
  //   setState(() {});
  // }

  Future<void> addContactDetails(
      BuildContext context, String name, String email, String contact) async {
    FocusScope.of(context).unfocus();
    // toggleLoading(true);
    try {
      await addContact(
        context,
        name,
        email,
        contact,
      );
      // toggleLoading(false);
    } catch (e) {
      // toggleLoading(false);
      PlatformAlertDialog(
        title: 'Error',
        content: 'Not able to process you contact details',
        defaultActionText: 'Ok',
      ).show(context);
    }
  }

  // bool isValidContact() {
  //   return _nameController.text.isNotEmpty &&
  //       _emailController.text.isNotEmpty &&
  //       _contactController.text.isNotEmpty &&
  //       _contactController.text.length == 10;
  // }

  // static final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController _contactController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _nameController = TextEditingController();

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Withdrawing first time, please fill the required details',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
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
                          if (value.length < 10)
                            return 'Invalid contact number';
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
            shape: kCardShape(10.0),
            color: kAppBackgroundColor,
            child: Text(
              '   Submit   ',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            disabledColor: Colors.grey,
            onPressed: () {
              if (formKey.currentState.validate()) {
                print('Valid');
                addContactDetails(context, _nameController.text,
                    _emailController.text, _contactController.text);
              } else {
                print('Invalid field');
              }
            },
            // onPressed: isValidContact() ? addContactDetails : null,
            // onPressed: isValidCont
            //     ? () => gotoCreateFundAcountView(context, database)
            //     : null,
          )
        ],
      ),
    );
  }
}
