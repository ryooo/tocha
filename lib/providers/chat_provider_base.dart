import 'package:flutter/cupertino.dart';

import 'package:chatapp/models/chat_model.dart';

class ChatProviderBase with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void addChatModel(ChatModel model) {
    chatList.add(model);
    notifyListeners();
  }

  void updateChatMessage(String id, String message) {
    for (var element in chatList) {
      if (element.id == id) {
        element.message = message;
      }
    }
    notifyListeners();
  }
}
