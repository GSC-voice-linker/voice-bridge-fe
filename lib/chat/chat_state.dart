//chat_state.dart 파일
import 'package:flutter/material.dart';

class Message {
  String id;
  String text;
  bool isMine;

  Message({required this.id, required this.text, required this.isMine});
}
class MessageProvider with ChangeNotifier {
  List<Message> messages = [];
  String? _tempAudioMessageId;
  String? _tempVideoMessageId;

  // 임시 메시지 추가 및 ID 반환 (구분자 추가)
  String addTemporaryMessage({required bool isAudio}) {
    String tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final tempMessage = Message(
        id: tempId,
        text: isAudio ? "·  ·  ·" : "·  ·  ·",
        isMine: !isAudio
    );
    messages.add(tempMessage);
    notifyListeners();

    if (isAudio) {
      _tempAudioMessageId = tempId;
    } else {
      _tempVideoMessageId = tempId;
    }

    return tempId;
  }

  // 기존 메시지 추가 메소드
  void addMessage(String text, bool isMine, {String? messageIdToUpdate}) {
    if (messageIdToUpdate != null) {
      // 기존 임시 메시지 업데이트
      int index = messages.indexWhere((msg) => msg.id == messageIdToUpdate);
      if (index != -1) {
        messages[index].text = text;
      } else {
        // 찾지 못한 경우 새 메시지 추가
        String messageId = DateTime.now().millisecondsSinceEpoch.toString();
        final message = Message(id: messageId, text: text, isMine: isMine);
        messages.add(message);
      }
    } else {
      // 새 메시지 추가
      String messageId = DateTime.now().millisecondsSinceEpoch.toString();
      final message = Message(id: messageId, text: text, isMine: isMine);
      messages.add(message);
    }
    notifyListeners();
  }

  // 메시지 업데이트
  void updateMessage(String idToUpdate, String newText) {
    int index = messages.indexWhere((msg) => msg.id == idToUpdate);
    if (index != -1) {
      messages[index].text = newText;
      notifyListeners();
    }
  }

  // 서버로부터 메시지를 가져와 리스트를 업데이트하는 메소드
  Future<void> getMessagesFromServer() async {
    List<Message> serverMessages = [
      // Message(id: DateTime.now().millisecondsSinceEpoch.toString(), text: '서버로부터의 메시지1', isMine: true),
      Message(id: DateTime.now().millisecondsSinceEpoch.toString(), text: '음성 테스트 메시지', isMine: false),
    ];

    messages.addAll(serverMessages);
    print('Messages from server added: ${serverMessages.length}');
    notifyListeners();
  }
}
