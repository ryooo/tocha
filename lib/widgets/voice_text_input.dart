import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/models/chat_model.dart';
import 'package:chatapp/providers/chat_provider_base.dart';
import 'package:chatapp/providers/image_generation_chat_provider.dart';
import 'package:chatapp/providers/setting_model_provider.dart';
import 'package:chatapp/providers/text_to_speach_provider.dart';
import 'package:chatapp/services/api_service.dart';
import 'package:flutter/material.dart';

import 'package:chatapp/constants/constants.dart';
import 'package:chatapp/providers/text_chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceTextInput extends StatefulWidget {
  final Function listScrollCallback;
  final ChatProviderBase chatProvider;
  const VoiceTextInput(
      {super.key,
      required this.listScrollCallback,
      required this.chatProvider});

  @override
  State<VoiceTextInput> createState() => _VoiceTextInputState();
}

class _VoiceTextInputState extends State<VoiceTextInput> {
  bool _isTyping = false;
  SpeechToText speechToText = SpeechToText();
  late FocusNode focusNode;

  var defaultHelpText = "";
  var helpText = "";

  bool isListening = false;

  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();

    switch (widget.chatProvider.runtimeType) {
      case TextChatProvider:
        defaultHelpText = "ききたいことをおくってください。\n\nマイクのボタンをおしているあいだは\nしゃべってください。";
        helpText = defaultHelpText;
        break;

      case ImageGenerationChatProvider:
        defaultHelpText =
            "どんなえをかきたいか、おくってください。\n\nマイクのボタンをおしているあいだは\nしゃべってください。";
        helpText = defaultHelpText;
        break;
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textToSpeachProvider = Provider.of<TextToSpeachProvider>(context);
    final settingModelProvider = Provider.of<SettingModelProvider>(context);
    return Material(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    maxLines: 5,
                    style: const TextStyle(color: Colors.black),
                    controller: textEditingController,
                    onSubmitted: (value) async {
                      await sendMessageFCT(
                        chatProvider: widget.chatProvider,
                        textToSpeachProvider: textToSpeachProvider,
                        settingModelProvider: settingModelProvider,
                      );
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: helpText,
                      hintStyle: const TextStyle(color: Colors.black45),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      iconSize: 30,
                      onPressed: () {
                        textEditingController.clear();
                      },
                      icon: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.backspace,
                          color: Colors.black45,
                          size: 15,
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 60,
                      onPressed: () async {
                        await sendMessageFCT(
                          chatProvider: widget.chatProvider,
                          textToSpeachProvider: textToSpeachProvider,
                          settingModelProvider: settingModelProvider,
                        );
                      },
                      icon: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                createVoiceButton(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget createVoiceButton() {
    return AvatarGlow(
      glowColor: const Color(0xFFFF007F),
      endRadius: 75.0,
      animate: isListening,
      duration: const Duration(milliseconds: 2000),
      repeat: true,
      repeatPauseDuration: const Duration(milliseconds: 100),
      showTwoGlows: true,
      child: GestureDetector(
        onTapDown: (details) async {
          if (!isListening) {
            var available = await speechToText.initialize();
            if (available) {
              setState(() {
                isListening = true;
                helpText = "しゃべってください";
              });
              speechToText.listen(onResult: (result) {
                setState(() {
                  textEditingController.text = result.recognizedWords;
                  debugPrint("============> ${textEditingController.text}");
                });
              });
            }
          }
        },
        onTapUp: (details) async {
          setState(() {
            isListening = false;
          });
          await speechToText.stop();

          helpText = defaultHelpText;
          debugPrint("<<<----Your Voice---->>>: ${textEditingController.text}");
        },
        child: CircleAvatar(
          backgroundColor: kVoiceColor,
          radius: 35,
          child: Icon(
            isListening ? Icons.mic : Icons.mic_none,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> sendMessageFCT({
    required ChatProviderBase chatProvider,
    required TextToSpeachProvider textToSpeachProvider,
    required SettingModelProvider settingModelProvider,
  }) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "さっきの返事を入力しているから、もう少しお待ち下さい",
            style: kSnackMessageItemStyle,
          ),
          backgroundColor: Colors.deepOrangeAccent,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "メッセージがありません",
            style: kSnackMessageItemStyle,
          ),
          backgroundColor: Colors.deepOrangeAccent,
        ),
      );
      return;
    }

    String message = textEditingController.text;
    try {
      setState(() {
        _isTyping = true;
        chatProvider.addChatModel(ChatModel(
          ChatMessageType.user,
          message,
          settingModelProvider.model.botCharacter.outputLang,
        ));
        textEditingController.clear();
        focusNode.unfocus();
        widget.listScrollCallback();
      });
      switch (widget.chatProvider.runtimeType) {
        case TextChatProvider:
          var model = ChatModel(
            ChatMessageType.bot,
            "",
            settingModelProvider.model.botCharacter.outputLang,
          );
          chatProvider.addChatModel(model);
          var botMessage = await ApiService.sendChatCompletions(
            message,
            chatProvider.chatList,
            settingModelProvider.model,
          );
          chatProvider.updateChatMessage(model.id, botMessage);
          if (settingModelProvider.model.textToSpeachSetting.isEnable) {
            Future.delayed(const Duration(milliseconds: 100), () {
              textToSpeachProvider.speakChatModel(
                  model, settingModelProvider.model.textToSpeachSetting);
            });
          }
          break;

        case ImageGenerationChatProvider:
          var model = ChatModel(
            ChatMessageType.botImage,
            "",
            null,
          );
          chatProvider.addChatModel(model);
          var botMessage =
              await ApiService.sendImagesGenerationsByJapanese(message);
          chatProvider.updateChatMessage(model.id, botMessage);
          break;
      }
      setState(() {});
    } catch (error) {
      setState(() {
        textEditingController.text = message;
      });
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "エラーが発生しました",
          style: kSnackMessageItemStyle,
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        widget.listScrollCallback();
        _isTyping = false;
      });
    }
  }
}
