import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonIcons {
  static Widget superCaptainIcon({Color color, double size}) {
    return ImageIcon(
      AssetImage("assets/images/super-captain1.png"),
      color: color ?? Colors.white,
      size: size ?? 50.0,
    );
  }

  static Widget captainIcon({Color color, double size}) {
    return ImageIcon(
      AssetImage("assets/images/captain.png"),
      color: color ?? Colors.white,
      size: size ?? 50.0,
    );
  }

  static Widget viceCaptainIcon({Color color, double size}) {
    return ImageIcon(
      AssetImage("assets/images/captain-cap.png"),
      color: color ?? Colors.white,
      size: size ?? 50.0,
    );
  }
}
