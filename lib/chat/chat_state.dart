//chat_state.dart 파일
import 'package:flutter/material.dart';


class Message {
  final String text; // 메시지를 담을 변수
  final bool isMine;  // ture라면 내가 보낸 것 false라면 상대방이 보낸 것

  Message({required this.text, required this.isMine});
}

// class MessageProvider with ChangeNotifier {
//   List<Message> messages = [];
//
//   void addMessage(String text, bool isMine) {
//     final message = Message(text: text, isMine: isMine);
//     messages.add(message);
//     notifyListeners(); // UI 업데이트를 위해 호출
//   }
// }

// 메시지 상태 관리를 위한 Provider
class MessageProvider with ChangeNotifier {
  List<Message> messages = [];

  // 새 메시지를 리스트에 추가하는 메소드
  void addMessage(String text, bool isMine) {
    final message = Message(text: text, isMine: isMine);
    messages.insert(0, message); // 메시지 리스트의 시작 부분에 추가
    print('Message added: $text'); // 콘솔에 메시지 추가 출력
    notifyListeners(); // UI 업데이트
  }

  // 서버로부터 메시지를 가져와 리스트를 업데이트하는 메소드
  Future<void> getMessagesFromServer() async {
    // 서버로부터 메시지를 가져오는 로직을 구현
    // 여기서는 예시로 하드코딩된 데이터를 사용
    List<Message> serverMessages = [
      Message(text: '서버로부터의 메시지1', isMine: false),
      Message(text: '서버로부터의 메시지2', isMine: false)
    ];

    messages.addAll(serverMessages); // 가져온 메시지를 기존 리스트에 추가
    notifyListeners(); // UI 업데이트
  }
}