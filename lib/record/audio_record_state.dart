//audio_record_state.dart 파일
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import  'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AudioRecordState extends ChangeNotifier {
  final AudioRecorder _audioRecorder = AudioRecorder(); // 녹음 객체(클래스 내에서만 쓰이고,private)
  String _audioPath = ""; // 녹음된 파일의 경로를 저장하는 변수
  bool _isRecording = false; // 녹음 중인지 여부를 저장하는 변수

  bool get isAudioRecording => _isRecording;
  String get audioPath => _audioPath;
  String _serverResponseAudioText = ''; //  서버로부터 받은 텍스트 저장하는 변수
  String get severResponseAudioText => _serverResponseAudioText; // 서버로부터 받은 텍스트 반환
  String upLoadText = ''; // 업로드 상태 저장 변수
  String upLoadText2 = ''; // 파일 존재여부
  Function? onStartRecording; // 메시지 로딩용 콜백함수 정의
  // 콜백 함수 추가 mainplage에서 텍스트를 chat list로 넘겨주기 위함
  Function(String)? onTextAudioReceived;// 콜백 함수
  AudioRecordState({this.onTextAudioReceived});

  String? tempAudioMessageId;

  Future<void> startRecording() async { // 녹음을 시작하는 함수
    _isRecording = true;// 녹음 중 상태로 변경
    if (await _audioRecorder.hasPermission()) {
      final config = RecordConfig( // 녹음 설정
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
        numChannels: 1, // 채널 수를 1로 설정하여 모노 녹음
      ); //녹음 파일 설정
      final directory = await getTemporaryDirectory(); // 임시 디렉토리 경로 가져오기
      _audioPath = '${directory.path}/audio.aac';// 파일 경로 생성 및 반환
      await _audioRecorder.start(config, path: _audioPath); //파일 경로로 녹음 시작
      onStartRecording?.call(); // 녹화 시작 시 콜백 호출 메시지 로딩용
      notifyListeners(); // 상태 변경 알림
      print("음성녹음 시작+++++++++++++++++++++++++++++++++++++++++++++++++");
    }
  }

  // 녹음 중지 및 파일 업로드
  Future<void> stopRecording() async { // 녹음 중지 함수
    print("음성녹음 중지 함수 실행+++++++++++++++++++++++++++++++++++++++++++++++++");
    await _audioRecorder.stop();// 녹음 중지
    _isRecording = false; // 녹음 중이 아님으로 변경
    notifyListeners();
    await _uploadRecordToServer();
    print("경로확인 $_audioPath+++++++++++++++++++++++++++++++++");

  }

  // 서버에 녹음 파일 업로드
  Future<void> _uploadRecordToServer() async {
    print(" 오디오 서버로 업로드+++++++++++++++++++++++++++++++++++++++++++++++++");
    // 서버 URL 수정
    final String url = dotenv.env['appSttKey'] ?? "https://example.com"; // .env에서 API_URL 읽기
    final File file = File(_audioPath); // _audioPath는 녹음 파일의 경로
    if (!file.existsSync()) {
      print("파일이 존재하지 않습니다.");
      upLoadText2 = "파일이 존재하지 않음!";
      return;
    }

    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "audio": await MultipartFile.fromFile(file.path, filename: path.basename(file.path)), // audio키에 파일을 할당
      });
      var response = await dio.post(url, data: formData);
      if (response.statusCode == 200) {
        print("파일 업로드 성공!+++++++++++++++++++++++++++++++++++++++++++++++++");
        // 서버로부터 받은 응답 데이터 처리
        final responseData = response.data;
        if (responseData.containsKey('text')) {
          _serverResponseAudioText = responseData['text']; // 'text' 값 추출
          print("서버 응답 텍스트: $_serverResponseAudioText");
          upLoadText = "파일 업로드 성공!";
          if(onTextAudioReceived != null) {
            onTextAudioReceived!(_serverResponseAudioText);
            notifyListeners();
            print("비디오 콜백함수 호출ㄹ++++++++++++++++++++++++++++++++++++++++++++++++++++++");
            print("${onTextAudioReceived}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
          } // serverResponseText를 콜백 함수로 전달

        } else {
          print("응답에 'text' 키가 없습니다.");
          upLoadText = "응답 데이터 오류!";
        }
      } else {
        print("업로드 실패: 상태 코드 ${response.statusCode}");
        upLoadText = "업로드 실패! 상태 코드: ${response.statusCode}";
      }
    } catch (e) {
      print("업로드 중 오류 발생: $e");
      upLoadText = "업로드 오류! 상세 정보 없음";
    }
    // 상태 업데이트를 위한 notifyListeners() 호출
    notifyListeners();
  }
  @override
  void dispose() { // 상태 관리 객체 해제
    _audioRecorder.dispose(); // 녹음 객체 해제
    super.dispose(); // 상태 관리 객체 해제

  }
}
