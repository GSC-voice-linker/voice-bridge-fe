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
            color: message.isMine ? Colors.blue[300] : Colors.grey,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
                bottomRight: message.isMine ? Radius.circular(0) : Radius.circular(12),
                bottomLeft:  message.isMine ? Radius.circular(12) : Radius.circular(0)
            ),
          ),
          width: 145,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            message.text,
            style: TextStyle(
                color: message.isMine ? Colors.black : Colors.white
            ),
          ),
        ),
      ],
    );
  }
}