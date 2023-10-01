import 'dart:convert';
import 'dart:io';

import 'package:chatapp/models/chat_model.dart';
import 'package:chatapp/models/setting_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chatapp/constants/api_consts.dart';

enum PurposeType {
  chat,
  imageGeneration,
}

//====================ChatGPT ChatBOT==========================
class ApiService {
  static Future<String> sendChatCompletions(
    String message,
    List<ChatModel> history,
    SettingModel settingModel,
  ) async {
    try {
      var messages = [
        {
          "role": "system",
          "content": settingModel.botCharacter.systemRole,
        }
      ];
      for (var i = 0; i < history.length; i++) {
        messages.add({
          "role": history[i].messageType == ChatMessageType.user
              ? "user"
              : "assistant",
          "content": history[i].message,
        });
      }
      messages.add({
        "role": "user",
        "content": message,
      });
      var response = await http.post(
        Uri.parse("$openAiBaseUrl/chat/completions"),
        headers: {
          'Authorization': 'Bearer $openAiApiKey',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": settingModel.openAiModel.name,
            "messages": messages,
          },
        ),
      );

      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }
      if (jsonResponse["choices"].length > 0) {
        return jsonResponse["choices"][0]["message"]["content"];
      }
      return "?";
    } catch (error) {
      debugPrint("error $error");
      rethrow;
    }
  }

  static Future<String> sendImagesGenerationsByJapanese(
      String inputText) async {
    var response = await http.post(
      Uri.parse("$openAiBaseUrl/chat/completions"),
      headers: {
        'Authorization': 'Bearer $openAiApiKey',
        "Content-Type": "application/json"
      },
      body: jsonEncode(
        {
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              // ignore: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings
              "content": "ユーザーからは画像生成のためのプロンプトが送られてきます。\n" +
                  "\n" +
                  "日本語で送られてきた場合は、画像生成のプロンプトとして解釈できるよう、英語に翻訳してください。\n" +
                  "英語で送られてきた場合は、そのままの文字列を返してください。"
            },
            {
              "role": "user",
              "content": inputText,
            }
          ]
        },
      ),
    );

    Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    if (jsonResponse['error'] != null) {
      throw HttpException(jsonResponse['error']["message"]);
    }
    if (jsonResponse["choices"].length > 0) {
      debugPrint(
          "translated text: ${jsonResponse["choices"][0]["message"]["content"]}");
      return await sendImagesGenerations(
          jsonResponse["choices"][0]["message"]["content"]);
    }
    return "?";
  }

  static Future<String> sendImagesGenerations(String inputText) async {
    var res = await http.post(Uri.parse("$openAiBaseUrl/images/generations"),
        headers: {
          'Authorization': 'Bearer $openAiApiKey',
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "prompt": inputText,
          "n": 1,
          "size": "256x256",
        }));

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      var imageUrl = data['data'][0]['url'].toString();
      return imageUrl;
    } else {
      debugPrint("Failed to fetch image");
      return "?";
    }
  }

  static Future<void> loadMasterData() async {
    final uri = Uri(
      scheme: "https",
      host: "storage.googleapis.com",
      path: "/geek-friend-static/master.json",
      queryParameters: {"t": DateTime.now().millisecondsSinceEpoch.toString()},
    );
    final response = await http.get(uri);
    final j = json.decode(utf8.decode(response.bodyBytes));
    BotCharacter.cachedData = (j['bot_characters'] as List)
        .map((row) => BotCharacter.fromJson(row as Map<String, dynamic>))
        .toList();
    SpeachToTextSetting.cachedData = (j['speach_to_text_setting'] as List)
        .map((row) => SpeachToTextSetting.fromJson(row as Map<String, dynamic>))
        .toList();
    TextToSpeachSetting.cachedData = (j['text_to_speach_setting'] as List)
        .map((row) => TextToSpeachSetting.fromJson(row as Map<String, dynamic>))
        .toList();
    OpenAiModel.cachedData = (j['open_ai_model'] as List)
        .map((row) => OpenAiModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }
}
