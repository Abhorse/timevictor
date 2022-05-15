import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TeamWidget extends StatelessWidget {
  const TeamWidget(
      {@required this.name, @required this.icon, this.colour, this.imageURL});

  final String name;
  final IconData icon;
  final Color colour;
  final String imageURL;

  Widget errorIcon() {
    return CircleAvatar(
      radius: 30.0,
      backgroundColor: colour ?? Colors.white,
      child: Icon(icon ?? FontAwesomeIcons.users),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        imageURL == null
            ? CircleAvatar(
                radius: 30.0,
                backgroundColor: colour ?? Colors.white,
                child: Icon(icon ?? FontAwesomeIcons.users),
              )
            : CircleAvatar(
                radius: 30.0,
                backgroundColor: colour ?? Colors.white,
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/Loading-Image.gif',
                  image: imageURL,
                  imageErrorBuilder: (context, imageURL, error) => errorIcon(),
                ),
              ),
        // Text(
        //   name,
        //   style: TextStyle(
        //     fontSize: 20.0,
        //     fontWeight: FontWeight.w700,
        //   ),
        // ),
      ],
    );
  }
}
