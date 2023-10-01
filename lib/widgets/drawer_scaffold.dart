import 'package:chatapp/constants/constants.dart';
import 'package:chatapp/screens/image_generate_page.dart';
import 'package:chatapp/screens/setting_page.dart';
import 'package:chatapp/screens/text_chat_page.dart';
import 'package:chatapp/widgets/screen_symbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:lottie/lottie.dart';

final GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

class DrawerScaffold extends StatelessWidget {
  final Widget child;
  const DrawerScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kMainButtonColor,
        child: Lottie.asset("assets/lottie/icon-hamburger.json", height: 40),
        onPressed: () => drawerKey.currentState!.toggle(),
      ),
      body: SliderDrawer(
        key: drawerKey,
        appBar: const SizedBox.shrink(),
        slider: _SliderView(drawerKey: drawerKey),
        child: SafeArea(child: child),
      ),
    );
  }
}

class _SliderView extends StatelessWidget {
  final GlobalKey<SliderDrawerState> drawerKey;
  const _SliderView({Key? key, required this.drawerKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 30),
          Lottie.asset('assets/lottie/chatapp-logo.json', height: 100),
          const SizedBox(
            height: 20,
          ),
          Text(
            'トッチャ',
            textAlign: TextAlign.center,
            style: kMidashiStyle,
          ),
          const SizedBox(height: 20),
          ...[
            Menu(TextChatPage.symbol),
            Menu(ImageGeneratePage.symbol),
            Menu(SettingPage.symbol),
          ]
              .map((menu) => _SliderMenuItem(menu: menu, drawerKey: drawerKey))
              .toList(),
        ],
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final Menu menu;
  final GlobalKey<SliderDrawerState> drawerKey;

  const _SliderMenuItem({
    Key? key,
    required this.menu,
    required this.drawerKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(menu.symbol.title, style: kMenuItemStyle),
        leading: Lottie.asset("assets/lottie/${menu.symbol.lottieFileName}",
            height: 40),
        onTap: () {
          drawerKey.currentState!.closeSlider();
          Navigator.pushNamed(context, menu.symbol.routeName);
        });
  }
}

class Quotes {
  final MaterialColor color;
  final String author;
  final String quote;

  Quotes(this.color, this.author, this.quote);
}

class Menu {
  final ScreenSymbol symbol;

  Menu(this.symbol);
}
