import 'package:flutter/material.dart';
import 'package:timevictor/screens/profile_pic_view.dart';

import '../constants.dart';

class ProfilePicWidget extends StatelessWidget {
  final String profilePicURL;
  final double radius;
  final String heroTag;

  const ProfilePicWidget({
    Key key,
    @required this.profilePicURL,
    this.radius,
    @required this.heroTag,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return profilePicURL == null || profilePicURL.isEmpty
        ? CircleAvatar(
            backgroundColor: Colors.white,
            radius: radius ?? 50.0,
            child: Icon(
              Icons.person,
              size: radius == null ? 80.0 : radius,
              color: kAppBackgroundColor,
            ),
          )
        : GestureDetector(
            child: Hero(
              tag: heroTag ?? 'profilePic',
              child: CircleAvatar(
                backgroundImage: NetworkImage(profilePicURL),
                backgroundColor: Colors.white,
                radius: radius ?? 50.0,
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ProfilePicView(
                  profilePicURL: profilePicURL,
                );
              }));
            },
          );
  }
}
