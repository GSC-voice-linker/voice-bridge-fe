import 'package:flutter/material.dart';
import 'mainpage.dart';
import 'cammer/camera_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CameraState(),
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

