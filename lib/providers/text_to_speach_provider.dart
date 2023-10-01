import 'package:chatapp/models/setting_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:chatapp/models/chat_model.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeachProvider with ChangeNotifier {
  ChatModel? chatModel;
  FlutterTts tts = FlutterTts();

  TextToSpeachProvider() {
    init();
  }

  Future init() async {
    tts.setLanguage("ja-JP");
    tts.setPitch(1.0);
    tts.setSpeechRate(0.5);
    tts.setVolume(1.0);
    tts.setStartHandler(() {
      debugPrint("===> TTS IS STARTED:");
    });
    tts.setCompletionHandler(() {
      debugPrint("===> COMPLETED!!!");
    });
    tts.setErrorHandler((message) {
      debugPrint("===> EROOR: $message");
    });
  }

  Future speakChatModel(
    ChatModel model,
    TextToSpeachSetting textToSpeachSetting,
  ) async {
    if (chatModel != null) {
      debugPrint("can not speak");
      return;
    }
    if (model.lang == null) {
      debugPrint("model.lang is null");
      return;
    }
    chatModel = model;
    notifyListeners();

    await tts.setLanguage(model.lang!);
    await tts.awaitSpeakCompletion(true);
    await tts.speak(model.message);
    chatModel = null;
    notifyListeners();
  }

  ChatModel? get speekingModel => chatModel;

  void stop() {
    tts.stop();
    chatModel = null;
    notifyListeners();
  }
}
