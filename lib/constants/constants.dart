import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Color kMainButtonColor = Colors.white;
Color kAccentColor = const Color.fromARGB(255, 255, 240, 215);
Color kHomeButtonColor = const Color.fromARGB(255, 253, 253, 250);

Color myWindowColor = const Color.fromARGB(255, 178, 255, 163);
Color secondWindowColor = const Color.fromARGB(255, 255, 255, 255);
Color kVoiceColor = const Color(0xFFF52887);

TextStyle kMidashiStyle = const TextStyle(
  fontFamily: "NotoSansJP-Regular",
  color: Colors.black,
  fontSize: 22,
);

TextStyle kMenuItemStyle = const TextStyle(
  fontFamily: "NotoSansJP-Regular",
  color: Colors.black,
  fontSize: 22,
);

TextStyle kMessageItemStyle = const TextStyle(
  color: Colors.black87,
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

TextStyle kSnackMessageItemStyle = const TextStyle(
  color: Colors.black87,
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

Widget randomLoading(Color color, double size) {
  var random = math.Random();
  switch (random.nextInt(16)) {
    case 0:
      return LoadingAnimationWidget.fallingDot(color: color, size: size);
    case 1:
      return LoadingAnimationWidget.fourRotatingDots(color: color, size: size);
    case 2:
      return LoadingAnimationWidget.prograssiveDots(color: color, size: size);
    case 3:
      return LoadingAnimationWidget.threeArchedCircle(color: color, size: size);
    case 4:
      return LoadingAnimationWidget.bouncingBall(color: color, size: size);
    case 5:
      return LoadingAnimationWidget.hexagonDots(color: color, size: size);
    case 6:
      return LoadingAnimationWidget.beat(color: color, size: size);
    case 7:
      return LoadingAnimationWidget.dotsTriangle(color: color, size: size);
    case 8:
      return LoadingAnimationWidget.halfTriangleDot(color: color, size: size);
    case 9:
      return LoadingAnimationWidget.twoRotatingArc(color: color, size: size);
    case 10:
      return LoadingAnimationWidget.horizontalRotatingDots(
          color: color, size: size);
    case 11:
      return LoadingAnimationWidget.newtonCradle(color: color, size: size);
    case 12:
      return LoadingAnimationWidget.inkDrop(color: color, size: size);
    case 13:
      return LoadingAnimationWidget.stretchedDots(color: color, size: size);
    case 14:
      return LoadingAnimationWidget.waveDots(color: color, size: size);
    default:
      return LoadingAnimationWidget.threeRotatingDots(color: color, size: size);
  }
}
