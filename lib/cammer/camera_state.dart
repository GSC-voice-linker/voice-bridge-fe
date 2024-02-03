import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
//카메라 상태 관리
//카메라 로직 구현

class CameraRecordState extends ChangeNotifier {
  CameraController? _cameraController; // 카메라 제어를 위한 변수
  bool _isVideoRecording = false; // 녹화 중인지 여부를 저장하는 변수
  String _videoPath = ""; // 녹화된 파일의 경로를 저장하는 변수
  String _serverResponseCameraText = ''; //  서버로부터 받은 오디오 텍스트 저장하는 변수
  String get severResponseCameraText => _serverResponseCameraText; // 서버로부터 받은 텍스트 반환
  String get cameraPath => _videoPath;

  Function(String)? onTextCameraReceived; // 콜백 함수
  CameraRecordState({this.onTextCameraReceived}) {
    _initializeCamera();
  }

  CameraController? get cameraController => _cameraController; // 카메라 제어 변수 반환
  bool get isCameraInitialized => _cameraController != null && _cameraController!.value.isInitialized; // 카메라 초기화 여부 반환
  bool get isVideoRecording => _isVideoRecording; // 녹화 중인지 여부 반환

  void _initializeCamera() async { // 카메라 초기화 함수
    final cameras = await availableCameras();
    CameraDescription? frontCamera;

    // 전면 카메라 찾기
    for (var camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.front) {
        frontCamera = camera;
        break; // 전면 카메라를 찾으면 반복문 종료
      }
    }

    // 전면 카메라가 없으면
    if (frontCamera != null) {
      _cameraController = CameraController(frontCamera, ResolutionPreset.high);
      await _cameraController!.initialize();
      notifyListeners();
    } else {
      print('전면 카메라를 찾을 수 없습니다.');
    }
  }


  void startRecording() async {// 녹화 시작 함수
    _isVideoRecording = true; // 녹화 중 상태로 변경
    // final directory = await getTemporaryDirectory(); // 임시 디렉토리 경로 가져오기
    // _cameraPath = '${directory.path}/video.mp4';// 파일 경로 생성 및 반환
    await _cameraController?.startVideoRecording(); // 카메라 녹화 시작
    notifyListeners(); // 상태 변경 알림
  }

  void stopRecording() async {
    final XFile? rawVideoFile = await _cameraController?.stopVideoRecording(); // 카메라 녹화 중지
    _serverResponseCameraText = '카메라 테스트메시지';// 서버텍스트로 옮겨지는지 테스트
    if(onTextCameraReceived != null) { // 콜백 함수가 null이 아니면
      onTextCameraReceived!(_serverResponseCameraText); // serverResponseText를 콜백 함수로 전달
    } // serverResponseText를 콜백 함수로 전달
    if (rawVideoFile != null) {
      // 애플리케이션 문서 디렉토리에 비디오 파일 저장할 경로 지정
      final Directory appDocDir = await getApplicationDocumentsDirectory(); // 애플리케이션 문서 디렉토리 경로 가져오기
      final String videoPath = '${appDocDir.path}/my_video.mp4';
      // 녹화된 비디오 파일을 지정된 경로로 이동
      await rawVideoFile.saveTo(videoPath); // 비디오 파일 저장
      print("비디오 파일이 저장된 경로: $videoPath"); // 비디오 파일 경로 출력
      _videoPath = videoPath; // _videoPath 변수 업데이트
      await _uploadVideoToServer(); // 수정된 부분: videoPath를 인자로 전달
      // notifyListeners(); // 상태 변경 알림
    }
    print('stop을눌렀을떄 false로 돌아오기전=====================');
    _isVideoRecording = false; // 녹화 중이 아님으로 변경
    print('stop을눌렀을떄 false로 돌아오는가?=====================$_isVideoRecording');
    notifyListeners(); // 상태 변경 알림
  }

  Future<void> _uploadVideoToServer() async {
    // 파일을 서버로 업로드하는 함수
    print("AUDIO UPLOAD RECORDING+++++++++++++++++++++++++++++++++++++++++++++++++");
    final String url = 'URL';
    final File file = File(_videoPath); // _audioPath는 녹음 파일의 경로
    if (!file.existsSync()) { // 파일이 존재하지 않으면
      print("파일이 존재하지 않습니다.");
      return;
    }

    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({ // FormData 객체 생성
          "video": await MultipartFile.fromFile(file.path, filename: path.basename(file.path)), // video키에 파일을 할당
      });
      var response = await dio.post(url, data: formData);
      if (response.statusCode == 200) {
        print(
            "비디오 파일 업로드 성공!+++++++++++++++++++++++++++++++++++++++++++++++++");
        final responseData = response.data;
        if (responseData.containsKey('text')) {
          _serverResponseCameraText = responseData['text']; // 'text' 값 추출
          // 추가적인 성공 로직 처리
        }
      }else {
        print("업로드 실패 ===========================================");
        // 실패 처리 로직
      }
    } catch (e) {
      print("업로드 에러발생=================================: $e");
      // 에러 처리 로직
    }
    notifyListeners();
  }
  @override
  void dispose() {
    // 상태 관리 객체 해제
    _cameraController?.dispose(); // 카메라 제어 객체 해제
    super.dispose(); // 상태 관리 객체 해제
  }
}

