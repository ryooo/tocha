import 'package:chatapp/providers/image_generation_chat_provider.dart';
import 'package:chatapp/widgets/back_scaffold.dart';
import 'package:chatapp/widgets/screen_symbol.dart';
import 'package:chatapp/widgets/screen_symbol_header.dart';
import 'package:chatapp/widgets/voice_text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatapp/widgets/chat_widget.dart';

class ImageGeneratePage extends StatefulWidget {
  static ScreenSymbol symbol = ScreenSymbol(
      Icons.brush, "おえかき", '/Image_generator', "icon-image-generate.json");
  const ImageGeneratePage({super.key});

  @override
  State<ImageGeneratePage> createState() => _ImageGeneratePageState();
}

class _ImageGeneratePageState extends State<ImageGeneratePage> {
  late ScrollController _listScrollController;

  @override
  void initState() {
    _listScrollController = ScrollController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        waitAndScrollListToEnd();
      });
    });
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ImageGenerationChatProvider>(context);
    return BackScaffold(
      child: Column(
        children: [
          ScreenSymbolHeader(ImageGeneratePage.symbol),
          Flexible(
            child: ListView.builder(
                controller: _listScrollController,
                itemCount: chatProvider.getChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(model: chatProvider.getChatList[index]);
                }),
          ),
          const SizedBox(height: 15),
          VoiceTextInput(
            chatProvider: chatProvider,
            listScrollCallback: waitAndScrollListToEnd,
          ),
        ],
      ),
    );
  }

  void waitAndScrollListToEnd() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut);
  }
}
