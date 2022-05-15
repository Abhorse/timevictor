import 'package:flutter/material.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/modals/notification.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/widgets/circular_loader.dart';

class MyNotifications extends StatelessWidget {
  List<Widget> notificationCard(List<NotificationData> notifications) {
    return notifications
        .map((notify) => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Card(
                shape: kCardShape(5),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            notify.date,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        notify.title.toUpperCase(),
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(notify.message),
                    ],
                  ),
                ),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: kAppBackgroundColor,
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirestoreDatabase(uid: '').getAllNotifications(),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.active) {
              List<NotificationData> notfications = snapshots.data;
              if (notfications != null && notfications.length != 0) {
                return ListView(
                  children: notificationCard(notfications),
                );
              } else
                return Text('You dont have any notification yet.');
            } else
              return CircularLoader();
          },
        ),
      ),
    );
  }
}
