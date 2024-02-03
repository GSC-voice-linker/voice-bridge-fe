//main.dart 파일
import 'package:flutter/material.dart';
import 'mainpage.dart';
import 'cammer/camera_state.dart';
import 'package:provider/provider.dart';
import 'record/audio_record_state.dart';
import 'chat/chat_state.dart';

void main() {
  runApp(
    MultiProvider( // 여러 객체 상태 관리
      providers: [
        ChangeNotifierProvider(create: (context) => CameraRecordState()),
        ChangeNotifierProvider(create: (context) => AudioRecordState()),
        ChangeNotifierProvider(create: (context) => MessageProvider()),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Bridge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Mainpage(),
    );
  }
}

