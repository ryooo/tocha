import 'dart:io';

import 'package:chatapp/providers/image_generation_chat_provider.dart';
import 'package:chatapp/providers/setting_model_provider.dart';
import 'package:chatapp/providers/text_chat_provider.dart';
import 'package:chatapp/providers/text_to_speach_provider.dart';
import 'package:chatapp/screens/setting_page.dart';
import 'package:chatapp/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_page.dart';
import 'screens/text_chat_page.dart';
import 'screens/splash_screen.dart';
import 'screens/image_generate_page.dart';

bool? seenOnBoard;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  // to show status bar
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
  );

  SharedPreferences pref = await SharedPreferences.getInstance();
  seenOnBoard = pref.getBool('ON_BOARDING') ?? true;
  // seenOnBoard = true;
  await ApiService.loadMasterData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TextChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ImageGenerationChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TextToSpeachProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingModelProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'トッチャ',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (_) => const SplashScreen(),
          HomePage.symbol.routeName: (_) => const HomePage(),
          ImageGeneratePage.symbol.routeName: (_) => const ImageGeneratePage(),
          TextChatPage.symbol.routeName: (_) => const TextChatPage(),
          SettingPage.symbol.routeName: (_) => const SettingPage(),
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
