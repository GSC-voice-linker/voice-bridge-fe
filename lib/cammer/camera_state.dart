import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

//카메라 상태 관리
//카메라 로직 구현

class CameraState extends ChangeNotifier {
  CameraController? _cameraController; // 카메라 제어를 위한 변수
  bool _isVideoRecording = false; // 녹화 중인지 여부를 저장하는 변수

  CameraState() {
    _initializeCamera(); // 카메라 초기화
  }
  CameraController? get cameraController => _cameraController; // 카메라 제어 변수 반환
  bool get isCameraInitialized => _cameraController != null && _cameraController!.value.isInitialized; // 카메라 초기화 여부 반환
  bool get isVideoRecording => _isVideoRecording;// 녹화 중인지 여부 반환

  void _initializeCamera() async {// 카메라 초기화 함수
    final cameras = await availableCameras();// 사용 가능한 카메라 목록을 가져옴
    if (cameras.isNotEmpty) {// 사용 가능한 카메라가 있으면
      _cameraController = CameraController(cameras.first, ResolutionPreset.max);// 카메라 제어 객체 생성
      await _cameraController!.initialize();// 카메라 초기화
      notifyListeners();
    }
  }

  void startRecording() async {// 녹화 시작 함수
    await _cameraController?.startVideoRecording();// 카메라 녹화 시작
    _isVideoRecording = true;// 녹화 중 상태로 변경
    notifyListeners();// 상태 변경 알림
  }

  void stopRecording() async {
    XFile? file = await _cameraController?.stopVideoRecording();
    if (file != null) {
      // 서버로 파일 업로드
      await _uploadFileToServer(file.path);
    }
    _isVideoRecording = false;
    notifyListeners();
  }

  @override
  void dispose() {// 상태 관리 객체 해제
    _cameraController?.dispose();// 카메라 제어 객체 해제
    super.dispose();// 상태 관리 객체 해제
  }
}

Future<void> _uploadFileToServer(String filePath) async {
  final url = Uri.parse("my-server-url");
  final request = http.MultipartRequest("POST", url);

  request.files.add(
    http.MultipartFile(
      'file',
      File(filePath).readAsBytes().asStream(),
      File(filePath).lengthSync(),
      filename: filePath.split("/").last,
    ),
  );

  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      print("File uploaded successfully");
      // 추가적인 성공 로직 처리
    } else {
      print("Failed to upload file");
      // 실패 처리 로직
    }
  } catch (e) {
    print("Error uploading file: $e");
    // 에러 처리 로직
  }
}
