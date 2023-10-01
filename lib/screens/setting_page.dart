import 'package:chatapp/models/setting_model.dart';
import 'package:chatapp/providers/setting_model_provider.dart';
import 'package:chatapp/widgets/back_scaffold.dart';
import 'package:chatapp/widgets/screen_symbol.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatefulWidget {
  static ScreenSymbol symbol =
      ScreenSymbol(Icons.home, "セッティング", '/setting', "icon-setting.json");
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var settingModelProvider = context.read<SettingModelProvider>();
    if (settingModelProvider.model.openAiApiKey != null) {
      setState(() {
        _textFieldController.text = settingModelProvider.model.openAiApiKey!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var settingModelProvider = Provider.of<SettingModelProvider>(context);
    return BackScaffold(
      child: SettingsList(
        sections: [
          const CustomSettingsSection(
            child: SizedBox(height: 50),
          ),
          SettingsSection(
            title: const Text('ChatGPTの設定'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading:
                    Lottie.asset('assets/lottie/chatapp-logo.json', height: 30),
                title: const Text('キャラクター設定'),
                value: Text(settingModelProvider.model.botCharacter.name),
                onPressed: (tileContext) async {
                  var botCharacters = BotCharacter.all();
                  await SelectDialog.showModal<BotCharacter>(
                    tileContext,
                    label: "キャラクター設定",
                    selectedValue: settingModelProvider.model.botCharacter,
                    items: List.generate(
                        botCharacters.length, (index) => botCharacters[index]),
                    onFind: (String filter) async {
                      return botCharacters
                          .where((element) => element.name.contains(filter))
                          .toList();
                    },
                    itemBuilder: (_, item, isSelected) {
                      return ListTile(
                        selected: isSelected,
                        title: Text(item.name),
                        subtitle: Text(
                          item.description,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        leading: isSelected
                            ? const Icon(Icons.check)
                            : const SizedBox.shrink(),
                      );
                    },
                    onChange: (selected) {
                      settingModelProvider.updateBotCharacter(selected);
                    },
                  );
                },
              ),
              SettingsTile.navigation(
                leading: Lottie.asset('assets/lottie/icon-text-chat.json',
                    height: 30),
                title: const Text('使用モデル'),
                value: Text(settingModelProvider.model.openAiModel.name),
                onPressed: (tileContext) async {
                  var openAiModels = OpenAiModel.all();
                  await SelectDialog.showModal<OpenAiModel>(
                    tileContext,
                    label: "使用モデル",
                    selectedValue: settingModelProvider.model.openAiModel,
                    items: List.generate(
                        openAiModels.length, (index) => openAiModels[index]),
                    onFind: (String filter) async {
                      return openAiModels
                          .where((element) => element.name.contains(filter))
                          .toList();
                    },
                    itemBuilder: (_, item, isSelected) {
                      return ListTile(
                        selected: isSelected,
                        title: Text(item.name),
                        subtitle: Text(
                          item.description,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        leading: isSelected
                            ? const Icon(Icons.check)
                            : const SizedBox.shrink(),
                      );
                    },
                    onChange: (selected) {
                      settingModelProvider.updateOpenAiModel(selected);
                    },
                  );
                },
              ),
              SettingsTile(
                leading: Lottie.asset('assets/lottie/icon-setting-key.json',
                    height: 30),
                title: const Text('APIキー'),
                trailing: Row(
                  children: [
                    DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                      ),
                      child: Text(
                          settingModelProvider.model.openAiApiKey == null
                              ? "未設定"
                              : "設定済み"),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.only(start: 6, end: 2),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                onPressed: (tileContext) async {
                  var value = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('OpenAIのAPIキーを入力してください'),
                          content: TextField(
                            controller: _textFieldController,
                            decoration: const InputDecoration(
                                hintText: "sk-xxxxxxxxxx"),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text("キャンセル"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            ElevatedButton(
                              child: const Text('OK'),
                              onPressed: () => Navigator.pop<String>(
                                  context, _textFieldController.text),
                            ),
                          ],
                        );
                      });
                  if (value != null) {
                    settingModelProvider.updateOpenAiApiKey(value);
                  }
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('ボイスの設定'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Lottie.asset('assets/lottie/icon-microphone.json',
                    height: 30),
                title: const Text('音声での入力'),
                value:
                    Text(settingModelProvider.model.speachToTextSetting.name),
                onPressed: (tileContext) async {
                  var speachToTextSettings = SpeachToTextSetting.all();
                  await SelectDialog.showModal<SpeachToTextSetting>(
                    tileContext,
                    label: "音声での入力",
                    showSearchBox: false,
                    constraints: const BoxConstraints(maxHeight: 130),
                    selectedValue:
                        settingModelProvider.model.speachToTextSetting,
                    items: List.generate(speachToTextSettings.length,
                        (index) => speachToTextSettings[index]),
                    itemBuilder: (_, item, isSelected) {
                      return ListTile(
                        selected: isSelected,
                        title: Text(item.name),
                        subtitle: Text(
                          item.description,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        leading: isSelected
                            ? const Icon(Icons.check)
                            : const SizedBox.shrink(),
                      );
                    },
                    onChange: (selected) {
                      settingModelProvider.updateSpeachToTextSetting(selected);
                    },
                  );
                },
              ),
              SettingsTile.navigation(
                leading:
                    Lottie.asset('assets/lottie/icon-volume.json', height: 30),
                title: const Text('回答の音声'),
                value:
                    Text(settingModelProvider.model.textToSpeachSetting.name),
                onPressed: (tileContext) async {
                  var textToSpeachSettings = TextToSpeachSetting.all();
                  await SelectDialog.showModal<TextToSpeachSetting>(
                    tileContext,
                    label: "回答の音声",
                    showSearchBox: false,
                    constraints: const BoxConstraints(maxHeight: 130),
                    selectedValue:
                        settingModelProvider.model.textToSpeachSetting,
                    items: List.generate(textToSpeachSettings.length,
                        (index) => textToSpeachSettings[index]),
                    itemBuilder: (_, item, isSelected) {
                      return ListTile(
                        selected: isSelected,
                        title: Text(item.name),
                        subtitle: Text(
                          item.description,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        leading: isSelected
                            ? const Icon(Icons.check)
                            : const SizedBox.shrink(),
                      );
                    },
                    onChange: (selected) {
                      settingModelProvider.updateTextToSpeachSetting(selected);
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
