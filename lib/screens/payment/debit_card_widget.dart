import 'package:flutter/material.dart';
import 'package:timevictor/constants.dart';

class PayoutCardWidget extends StatelessWidget {
  final String name;
  final String accountNumber;
  final String ifscCode;

  const PayoutCardWidget({
    Key key,
    this.name,
    this.accountNumber,
    this.ifscCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.0,
      height: 250.0,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Card(
          shape: kButtonShape,
          child: Container(
            decoration: BoxDecoration(
                color: kAppBackgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.grey],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.9],
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Text(
                    accountNumber,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Text(
                    ifscCode,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
