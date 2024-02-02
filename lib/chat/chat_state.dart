//chat_state.dart 파일
import 'package:flutter/material.dart';

class MessageProvider with ChangeNotifier {
  List<Message> messages = [];

  void addMessage(String text, bool isMine) {
    final message = Message(text: text, isMine: isMine);
    messages.add(message);
    notifyListeners(); // UI 업데이트를 위해 호출
  }
}

class Message {
  final String text; // 메시지를 담을 변수
  final bool isMine;  // ture라면 내가 보낸 것 false라면 상대방이 보낸 것

  Message({required this.text, required this.isMine});
}
