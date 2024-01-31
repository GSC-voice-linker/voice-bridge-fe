import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';


class AudioRecordState extends ChangeNotifier {
  final AudioRecorder _audioRecorder = AudioRecorder(); // 녹음 객체(클래스 내에서만 쓰이고,private)
  String _audioPath = "";
  bool _isRecording = false; // 녹음 중인지 여부를 저장하는 변수

  bool get isRecording => _isRecording;
  String get audioPath => _audioPath;
  String serverResponseText = ''; //  서버로부터 받은 텍스트 저장하는 변수

  // 녹음 시작
  Future<void> startRecording() async { // 녹음을 시작하는 함수
    if (await _audioRecorder.hasPermission()) {
      final config = RecordConfig( // 녹음 설정
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      );
      final directory = await getTemporaryDirectory(); // 임시 디렉토리 경로 가져오기
      _audioPath = '${directory.path}/audio.aac';// 파일 경로 생성 및 반환

      await _audioRecorder.start(config, path: _audioPath); //파일 경로로 녹음 시작
      _isRecording = true;// 녹음 중 상태로 변경
      notifyListeners(); // 상태 변경 알림
    }
  }

  // 녹음 중지 및 파일 업로드
  Future<void> stopRecording() async { // 녹음 중지 함수
    await _audioRecorder.stop();// 녹음 중지
    _isRecording = false; // 녹음 중이 아님으로 변경
    notifyListeners();
    await _uploadRecording();
  }

  // 서버에 녹음 파일 업로드
  Future<void> _uploadRecording() async {
    final url = Uri.parse('http://35.197.3.194:8000/stt/'); // 서버 URL 지정
    final file = File(_audioPath); // 녹음 파일 경로 지정

    if (!file.existsSync()) {
      print("파일이 존재하지 않습니다.");
      return;
    }

    try {
      final request = http.MultipartRequest('POST', url)
        ..files.add(
          http.MultipartFile(
            'file',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: path.basename(file.path),
          ),
        );

      final response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final textResult = responseData['text']; // 서버로부터 받은 'text' 값
        serverResponseText = textResult; // serverResponseText 업데이트
        notifyListeners(); // 상태 변경 알림
        print("파일 업로드 성공!"); // 업로드 성공시 메시지 출력
      } else {
        // 업로드 실패 처리
        print("파일 업로드 실패: ${response.statusCode}"); // 업로드 실패시 메시지 출력
      }
    } catch (e) {
      print("업로드 중 오류 발생: $e"); // 오류 발생시 메시지 출력
      // 오류 처리
    }
  }

  @override
  void dispose() { // 상태 관리 객체 해제
    _audioRecorder.dispose(); // 녹음 객체 해제
    super.dispose(); // 상태 관리 객체 해제
  }
}
