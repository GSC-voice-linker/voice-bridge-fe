import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';


//녹음 상태 관리
//녹음 로직 구현

class Record extends ChangeNotifier {
  final Record _audioRecord = Record();//오디오 레코드
  String _audioPath = ""; // 녹음된 파일의 경로를 저장하는 변수
  bool _isAudioRecording = false; // 녹음 중인지 여부를 저장하는 변수

  bool get isRecording => _isAudioRecording; // 녹음 중인지 여부 반환
  String get audioPath => _audioPath; // 녹음된 파일의 경로 반환


  // 녹음 시작
  Future<void> startRecording() async {
    if (await _audioRecord.hasPermission()) { // 권한 확인
      final config = RecordConfig(// 녹음 설정
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      );
      final directory = await getTemporaryDirectory();// 임시 디렉토리 경로 가져오기
      _audioPath = '${directory.path}/my_recording.aac';// 파일 경로 생성

      await _audioRecord.start(config, path: _audioPath);// 녹음 시작
      _isAudioRecording = true;// 녹음 중 상태로 변경
      notifyListeners();// 상태 변경 알림
    }
  }

  // 녹음 중지
  Future<void> stopRecording() async {
    await _audioRecord.stop();
    _isAudioRecording = false;
    notifyListeners();
    await uploadRecording();
  }


  Future<void> uploadRecording() async { // 녹음된 파일을 서버에 업로드하는 함수
    final url = Uri.parse('YOUR_SERVER_UPLOAD_URL'); // 서버 업로드 URL
    final file = File(_audioPath);

    if (!file.existsSync()) {
      print("파일이 존재하지 않습니다.");
      return;
    }

    try {
      final request = http.MultipartRequest('POST', url)
        ..files.add(
          http.MultipartFile(
            'file', // 서버에서 예상하는 필드 이름
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: basename(file.path),
          ),
        );

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        print('파일 업로드 성공');
      } else {
        print('파일 업로드 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('파일 업로드 중 오류 발생: $e');
    }

  }

  @override
  void dispose() {
    _audioRecord.dispose();
    super.dispose();
  }



}