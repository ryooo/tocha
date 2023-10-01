import 'package:chatapp/constants/constants.dart';
import 'package:chatapp/widgets/screen_symbol.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ScreenSymbolHeader extends StatelessWidget {
  final ScreenSymbol symbol;
  const ScreenSymbolHeader(this.symbol, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset("assets/lottie/${symbol.lottieFileName}", height: 40),
        const SizedBox(width: 10),
        Text(symbol.title, style: kMidashiStyle)
      ],
    );
  }
}
