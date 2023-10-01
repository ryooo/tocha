class ChatModel {
  static int _id = 1;
  late String id;
  late String message;
  final ChatMessageType messageType;
  late String? lang;

  ChatModel(this.messageType, this.message, this.lang) {
    id = (_id++).toString();
  }
}

enum ChatMessageType { user, bot, botImage }
