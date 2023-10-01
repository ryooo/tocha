import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:chatapp/models/setting_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingModelProvider with ChangeNotifier {
  late SettingModel model;
  SettingModelProvider() {
    loadJson();
  }

  loadJson() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var jsonString = pref.getString('SETTING_MODEL');
    if (jsonString == null) {
      model = SettingModel();
    } else {
      model = SettingModel.fromJson(json.decode(jsonString));
    }
  }

  void updateBotCharacter(BotCharacter selected) {
    model.botCharacterId = selected.id;
    notifyListeners();
  }

  void updateOpenAiModel(OpenAiModel selected) {
    model.openAiModelId = selected.id;
    notifyListeners();
  }

  void updateOpenAiApiKey(String key) {
    model.openAiApiKey = key;
    notifyListeners();
  }

  void updateSpeachToTextSetting(SpeachToTextSetting selected) {
    model.speachToTextSettingId = selected.id;
    notifyListeners();
  }

  void updateTextToSpeachSetting(TextToSpeachSetting selected) {
    model.textToSpeachSettingId = selected.id;
    notifyListeners();
  }
}
