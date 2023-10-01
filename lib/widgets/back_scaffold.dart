import 'package:chatapp/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BackScaffold extends StatelessWidget {
  final Widget child;
  const BackScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kMainButtonColor,
        child: Lottie.asset("assets/lottie/icon-home.json", height: 40),
        onPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(child: child),
    );
  }
}
