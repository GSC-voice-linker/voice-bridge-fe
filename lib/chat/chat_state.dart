//chat_state.dart 파일
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Message {
  String id;
  String text;
  bool isMine;

  Message({required this.id, required this.text, required this.isMine});
}
class MessageProvider with ChangeNotifier {
  List<Message> messages = [
    Message(id: DateTime.now().millisecondsSinceEpoch.toString(), text: '금요일에 회의 참석 가능하신가요?', isMine: true),
    Message(id: DateTime.now().millisecondsSinceEpoch.toString(), text: '일정을 한번 확인해보겠습니다 어떤 회의인가요', isMine: false),
  ];
  String? _tempAudioMessageId;
  String? _tempVideoMessageId;

  FlutterTts flutterTts = FlutterTts(); // TTS 객체 생성
  Map<String, String> voice = {"name": "ko-kr-x-ism-local", "locale": "ko-KR"};
  String engine = "com.google.android.tts";
  double volume = 0.8;
  double pitch = 1.0;
  double rate = 0.5;

  Future<void> speak(String text) async { // TTS로 텍스트 읽기
    await flutterTts.speak(text); // TTS로 텍스트 읽기
  }

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
    print('addMessage 메소드 실행++++++++++++++++++++++++++++++++++++++++++++');

    if (messageIdToUpdate != null) {
      // 기존 임시 메시지 업데이트
      int index = messages.indexWhere((msg) => msg.id == messageIdToUpdate); // 기존 메시지의 인덱스 찾기
      if (index != -1) {
        messages[index].text = text; //
        print('기존 임시 메시지 업데이트++++++++++++++++++++++++++++++++++++++++++++');
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
  void updateMessage(String idToUpdate, String newText, bool isMine) { // isMine 파라미터 추가
    int index = messages.indexWhere((msg) => msg.id == idToUpdate);
    if (index != -1) {
      messages[index].text = newText;
      // 메시지의 isMine 상태를 확인하고 true일 경우 TTS로 메시지를 읽습니다.
      if (isMine) {
        speak(newText); // TTS로 newText 읽기
      }
      notifyListeners();
    }
  }

  // 서버로부터 메시지를 가져와 리스트를 업데이트하는 메소드
  // Future<void> getMessagesFromServer() async {
  //   List<Message> serverMessages = [
  //     // Message(id: DateTime.now().millisecondsSinceEpoch.toString(), text: '서버로부터의 메시지1', isMine: true),
  //     Message(id: DateTime.now().millisecondsSinceEpoch.toString(), text: '음성 테스트 메시지', isMine: false),
  //   ];
  //   messages.addAll(serverMessages); // 서버로부터 받은 메시지를 추가
  //   print('Messages from server added: ${serverMessages.length}');
  //   notifyListeners();
  // }
}
