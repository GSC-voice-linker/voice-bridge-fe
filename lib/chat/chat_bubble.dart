// message_bubble.dart 파일
import 'package:flutter/material.dart';
import 'package:voice_bridge_main/chat/chat_state.dart';


class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: message.isMine ? Color(0xff5290DB) : Color(0xffABABAB), // 채팅 버블의 색상 설정
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
                bottomRight: message.isMine ? Radius.circular(0) : Radius.circular(12),
                bottomLeft:  message.isMine ? Radius.circular(12) : Radius.circular(0)
            ),
          ),
          width: 160,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),  // 채팅 버블의 패딩 설정
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20), // 채팅 버블의 마진 설정
          child: Text(
            message.text,
            style: TextStyle(
              fontFamily: 'OnlyAppbar',
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}