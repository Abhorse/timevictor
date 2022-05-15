import 'package:flutter/material.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/modals/transaction.dart';
import 'package:timevictor/utils/dateTime_formater.dart';

class TransactionCardWidget extends StatelessWidget {
  final PayTransaction transaction;

  const TransactionCardWidget({Key key, this.transaction}) : super(key: key);

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

  Color getIconColour() {
    if (transaction.isSuccess) return Colors.green;
    // if (transaction.signature == "processed") return Colors.green;
    // if (transaction.signature == "cancelled") return Colors.red;

    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    // if (transaction.contestName == "Payout") {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 5.0,
      ),
      child: Card(
        child: ExpansionTile(
          backgroundColor: Colors.white,
          title: transaction.contestName == "Payout"
              ? newCard(context)
              : oldCard(context),
          children: [
            keyValuePair(
              'Transaction ID',
              transaction.transactionID,
              false,
            ),
            keyValuePair(
              'Date',
              FormattedDateTime.paymentFormat(transaction.time),
              false,
            ),
            keyValuePair(
              'Remark',
              transaction.contestName == "Payout"
                  ? 'Amount withdrawn from wallet'
                  : transaction.transactionID.contains('WIN')
                      ? 'Won Prize in contest ${transaction.contestName} in ${transaction.match}'
                      : 'For joining contest ${transaction.contestName} in ${transaction.match}',
              true,
            ),
          ],
        ),
      ),
    );
    // }
    // return oldCard(context);
    // return Padding(
    //   padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
    //   child: Card(
    //     child: ExpansionTile(
    //       backgroundColor: Colors.white,
    //       title: oldCard(context),
    //       children: [
    //         keyValuePair(
    //           'Transaction ID',
    //           transaction.transactionID,
    //         ),
    //         keyValuePair(
    //           'Time',
    //           FormattedDateTime.paymentFormat(transaction.time),
    //         ),
    //         keyValuePair('Match', transaction.match),
    //         keyValuePair('Remark', 'joined ${transaction.contestName}'),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget newCard(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: CircleAvatar(
                radius: 20.0,
                backgroundColor: getIconColour(),
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Withdrawn',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  transaction.isSuccess ? 'Success' : 'Failed',
                  style: TextStyle(
                    color: getIconColour(),
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
              '$kRupeeSymbol ${transaction.amount}',
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

  Widget oldCard(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    child: Icon(
                      transaction.isDebited
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    backgroundColor:
                        transaction.isSuccess ? Colors.green : Colors.red,
                  ),
                ),
                // Text(
                //   transaction.isSuccess ? 'Success' : 'Failed',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     color: transaction.isSuccess ? Colors.green : Colors.red,
                //   ),
                // )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.isDebited ? transaction.paymentMethod : 'Wallet',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  transaction.isDebited ? 'Debited From' : 'Recivied to',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  transaction.isSuccess ? 'Success' : 'Failed',
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: transaction.isSuccess ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
        Text(
          '$kRupeeSymbol ${transaction.amount} ',
          style: TextStyle(
            color: kAppBackgroundColor,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
