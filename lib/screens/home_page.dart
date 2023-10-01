import 'package:chatapp/constants/constants.dart';
import 'package:chatapp/providers/setting_model_provider.dart';
import 'package:chatapp/screens/setting_page.dart';
import 'package:chatapp/screens/text_chat_page.dart';
import 'package:chatapp/screens/image_generate_page.dart';
import 'package:chatapp/widgets/screen_symbol.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static ScreenSymbol symbol =
      ScreenSymbol(Icons.home, "ホーム", '/home', "icon-home.json");
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final _ = Provider.of<SettingModelProvider>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kMainButtonColor,
        child: Lottie.asset("assets/lottie/icon-setting.json", height: 40),
        onPressed: () =>
            Navigator.pushNamed(context, SettingPage.symbol.routeName),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottie/chatapp-logo.json', height: 100),
              const SizedBox(height: 20),
              Text(
                'トッチャ',
                textAlign: TextAlign.center,
                style: kMidashiStyle,
              ),
              const SizedBox(height: 180),
              _HomeItem(symbol: ImageGeneratePage.symbol),
              const SizedBox(height: 30),
              _HomeItem(symbol: TextChatPage.symbol),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeItem extends StatelessWidget {
  final ScreenSymbol symbol;

  const _HomeItem({Key? key, required this.symbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, symbol.routeName);
      },
      child: Container(
        alignment: Alignment.center,
        width: 280,
        height: 120,
        decoration: BoxDecoration(
            color: kHomeButtonColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade500,
                  offset: const Offset(4, 4),
                  blurRadius: 15,
                  spreadRadius: 1),
              const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 15,
                  spreadRadius: 1),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/lottie/${symbol.lottieFileName}", height: 60),
            const SizedBox(width: 5),
            Text(symbol.title, style: kMenuItemStyle)
          ],
        ),
      ),
    );
  }
}
