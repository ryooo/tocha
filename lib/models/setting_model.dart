// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'dart:convert';

class BotCharacter {
  final int id;
  final String name;
  final String description;
  final String systemRole;
  final String inputLang;
  final String outputLang;

  BotCharacter({
    required this.id,
    required this.name,
    required this.description,
    required this.systemRole,
    required this.inputLang,
    required this.outputLang,
  });

  factory BotCharacter.fromJson(Map<String, dynamic> json) => BotCharacter(
        id: json["id"],
        name: json["name"],
        description: json["description"].replaceAll("\\n", "\n"),
        systemRole: json["system_role"].replaceAll("\\n", "\n"),
        inputLang: json["input_lang"],
        outputLang: json["output_lang"],
      );

  static List<BotCharacter> cachedData = [];
  static List<BotCharacter> all() => cachedData;
}

class SpeachToTextSetting {
  final int id;
  final String name;
  final String description;

  SpeachToTextSetting({
    required this.id,
    required this.name,
    required this.description,
  });

  factory SpeachToTextSetting.fromJson(Map<String, dynamic> json) =>
      SpeachToTextSetting(
        id: json["id"],
        name: json["name"],
        description: json["description"].replaceAll("\\n", "\n"),
      );

  static List<SpeachToTextSetting> cachedData = [];
  static List<SpeachToTextSetting> all() => cachedData;
  bool get isEnable => id == 1;
}

class TextToSpeachSetting {
  final int id;
  final String name;
  final String description;

  TextToSpeachSetting({
    required this.id,
    required this.name,
    required this.description,
  });

  factory TextToSpeachSetting.fromJson(Map<String, dynamic> json) =>
      TextToSpeachSetting(
        id: json["id"],
        name: json["name"],
        description: json["description"].replaceAll("\\n", "\n"),
      );

  static List<TextToSpeachSetting> cachedData = [];
  static List<TextToSpeachSetting> all() => cachedData;
  bool get isEnable => id == 1;
}

class OpenAiModel {
  final int id;
  final String name;
  final String description;

  OpenAiModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory OpenAiModel.fromJson(Map<String, dynamic> json) => OpenAiModel(
        id: json["id"],
        name: json["name"],
        description: json["description"].replaceAll("\\n", "\n"),
      );

  static List<OpenAiModel> cachedData = [];
  static List<OpenAiModel> all() => cachedData;
}

class SettingModel {
  int botCharacterId;
  int speachToTextSettingId;
  int textToSpeachSettingId;
  int openAiModelId;
  String? openAiApiKey;

  SettingModel({
    this.botCharacterId = 1,
    this.speachToTextSettingId = 1,
    this.textToSpeachSettingId = 1,
    this.openAiModelId = 1,
    this.openAiApiKey,
  });

  BotCharacter get botCharacter {
    return BotCharacter.cachedData.firstWhere(
        (element) => element.id == botCharacterId,
        orElse: () => BotCharacter.cachedData[0]);
  }

  SpeachToTextSetting get speachToTextSetting {
    return SpeachToTextSetting.cachedData.firstWhere(
        (element) => element.id == speachToTextSettingId,
        orElse: () => SpeachToTextSetting.cachedData[0]);
  }

  TextToSpeachSetting get textToSpeachSetting {
    return TextToSpeachSetting.cachedData.firstWhere(
        (element) => element.id == textToSpeachSettingId,
        orElse: () => TextToSpeachSetting.cachedData[0]);
  }

  OpenAiModel get openAiModel {
    return OpenAiModel.cachedData.firstWhere(
        (element) => element.id == openAiModelId,
        orElse: () => OpenAiModel.cachedData[0]);
  }

  SettingModel copyWith({
    int? botCharacterId,
    int? speachToTextSettingId,
    int? textToSpeachSettingId,
    int? openAiModelId,
    String? openAiApiKey,
  }) =>
      SettingModel(
        botCharacterId: botCharacterId ?? this.botCharacterId,
        speachToTextSettingId:
            speachToTextSettingId ?? this.speachToTextSettingId,
        textToSpeachSettingId:
            textToSpeachSettingId ?? this.textToSpeachSettingId,
        openAiModelId: openAiModelId ?? this.openAiModelId,
        openAiApiKey: openAiApiKey ?? this.openAiApiKey,
      );

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        botCharacterId: json["botCharacterId"] ?? 1,
        speachToTextSettingId: json["speachToTextSettingId"] ?? 2,
        textToSpeachSettingId: json["textToSpeachSettingId"] ?? 2,
        openAiModelId: json["openAiModelId"] ?? 1,
        openAiApiKey: json["openAiApiKey"],
      );

  String toJson() => json.encode(this);
}
