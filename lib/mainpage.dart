import 'dart:io'; //파일 입출력 라이브러리
import 'package:flutter/material.dart'; //플러터 라이브러리
import 'package:provider/provider.dart'; //상태관리 라이브러리
import 'package:http/http.dart' as http; //http 통신 라이브러리
import 'package:audioplayers/audioplayers.dart'; //오디오 플레이어 라이브러리
import 'cammer/camera_widget.dart'; // 카메라 위젯(뷰어,녹화버튼)
import 'cammer/camera_state.dart'; //카메라 상태관리, 카메라 함수들 로직
import 'package:record/record.dart'; //녹음 라이브러리
import 'record/audio_record_state.dart'; // 녹음 위젯(녹음버튼)
import 'dart:convert';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});//

  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  late final AudioRecorder audioRecord; //Record 클래스 인스턴스
  late AudioPlayer audioPlayer;
  bool isAudioRecording = false; // 녹음 중인지 여부를 저장하는 변수
  late CameraControlWidget cameraControl; //카메라 녹화 클래스 인스턴스
  // String audioPath = ""; // 녹음된 파일의 경로를 저장하는 변수 .state파일에서 관리함으로 제거


  @override
  void initState() {
    super.initState();
    // audioPlayer = AudioPlayer(); //AudioPlayer 객체 초기화 .State 파일 생겨서 제거
    // audioRecord = AudioRecorder(); //레코드 객체 초기화
  }

  @override
  void dispose() {
    super.dispose();
    // audioRecord.dispose(); //AudioRecorder 자원 해제 state 파일 생겨서 제거
    // audioPlayer.dispose(); //AudioPlayer 자원 해제
  }
  bool playing=false;
  //
  // Future<String> _getAudioFilePath() async { // 임시 디렉토리 경로를 얻고 녹음 파일 경로를 반환 하는 함수
  //   final directory = await getTemporaryDirectory(); // 임시 디렉토리 경로 가져오기
  //   return '${directory.path}/my_recording.aac'; // 파일 경로 생성 및 반환
  // }
  //
  // Future<void> startRecording() async { // 녹음을 시작하는 함수
  //   try {
  //     print("START RECODING+++++++++++++++++++++++++++++++++++++++++++++++++");
  //     if (await audioRecord.hasPermission()) {
  //       final config = RecordConfig(
  //         encoder: AudioEncoder.aacLc, // 코덱 설정
  //         bitRate: 128000, // 비트레이트 설정
  //         sampleRate: 44100, // 샘플링레이트 설정
  //       );
  //       String path = await _getAudioFilePath(); // 파일 경로 가져오기
  //       await audioRecord.start(config, path: path); //파일 경로로 녹음 시작
  //       setState(() {
  //         isAudioRecording = true;
  //         audioPath = path; //오디오 path 업데이트
  //       });
  //     }
  //   } catch (e, stackTrace) {
  //     print("START RECODING+++++++++++++++++++++${e}++++++++++${stackTrace}+++++++++++++++++");
  //   }
  // }
  //
  // Future<void> stopRecording() async { // 녹음을 중지하는 함수
  //   try {
  //     print("STOP RECODING+++++++++++++++++++++++++++++++++++++++++++++++++");
  //     String? path = await audioRecord.stop();
  //     setState(() {
  //       recoding_now = false;
  //       isAudioRecording = false; //녹음 중지 상태로 업데이트
  //       audioPath = path?? ''; //바로 업로드 로직
  //       // audioPath = path!; // 기존코드
  //     });
  //     if (path != null) { //업로드 로직
  //       await uploadAndDeleteRecording();
  //     }
  //   } catch (e) {
  //     print("STOP RECODING+++++++++++++++++++++${e}+++++++++++++++++++++++++++");
  //   }
  // }
  //
  //
  // Future<void> uploadAndDeleteRecording() async { // 녹음된 파일을 서버에 업로드하고 삭제하는 함수
  //   try {
  //     final url = Uri.parse('YOUR_UPLOAD_URL'); // Replace with your server's upload URL
  //
  //     final file = File(audioPath);
  //     if (!file.existsSync()) {
  //       print("UPLOADING FILE NOT EXIST+++++++++++++++++++++++++++++++++++++++++++++++++");
  //       return;
  //     }
  //     print("UPLOADING FILE ++++++++++++++++${audioPath}+++++++++++++++++++++++++++++++++");
  //     final request = http.MultipartRequest('POST', url)
  //       ..files.add(
  //         http.MultipartFile(
  //           'audio',
  //           file.readAsBytes().asStream(),
  //           file.lengthSync(),
  //           filename: 'audio.mp3', // You may need to adjust the file extension
  //         ),
  //       );
  //
  //     final response = await http.Response.fromStream(await request.send());
  //
  //     if (response.statusCode == 200) {
  //       // Upload successful, you can delete the recording if needed
  //       // Show a snackbar or any other UI feedback for a successful upload
  //       const snackBar = SnackBar(
  //         content: Text('Audio uploaded.'),
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //
  //       // Refresh the UI
  //       setState(() {
  //         audioPath = "";
  //       });
  //     } else {
  //       // Handle the error or show an error message
  //       print('Failed to upload audio. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error uploading audio: $e');
  //   }
  // }
  //
  // Future<void> deleteRecording() async { // 녹음된 파일을 삭제하는 함수
  //
  //   if (audioPath.isNotEmpty) {
  //     try {
  //       recoding_now=true;
  //       File file = File(audioPath);
  //       if (file.existsSync()) {
  //         file.deleteSync();
  //         const snackBar = SnackBar(
  //           content: Text('Recoding deleted'),);
  //         print("FILE DELETED+++++++++++++++++++++++++++++++++++++++++++++++++");
  //       }
  //     } catch (e) {
  //       print("FILE NOT DELETED++++++++++++++++${e}+++++++++++++++++++++++++++++++++");
  //     }
  //
  //     setState(() {
  //       audioPath = "";
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) { //main페이지 빌드
    var cameraState = Provider.of<CameraState>(context); // 카메라 상태 가져오기
    var recordState = Provider.of<AudioRecordState>(context); // 녹음 상태 가져오기


    return Scaffold(
      appBar: AppBar(
        title: const Text('VOICE BRIDGE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Handle help action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ClipRRect( //카메라 뷰 출력 화면
              borderRadius: BorderRadius.circular(12), // 원하는 둥근 모서리 반경 설정
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5, //좌우의 50퍼센트만씀
                height: MediaQuery.of(context).size.width * (4 / 3) * 0.5, //그 50퍼센트에서 4대3비율로 출력
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CameraView(), // 카메라 뷰어
              ),
            ),
            const SizedBox(height: 29),
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  // 채팅 화면 컨테이너 스타일 설정
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(recordState.serverResponseText), // 서버로부터 받은 응답 출력
                  ),
                ),
              ),
            ),
            const SizedBox(height: 33),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton( // 녹음 버튼
                  icon: Icon(
                    recordState.isRecording ? Icons.stop : Icons.mic, // 녹음 중이면 정지 아이콘, 아니면 마이크 아이콘
                    size: 50,
                  ),
                  onPressed: () {
                    if (recordState.isRecording) {
                      recordState.stopRecording(); // 녹음 중지
                    } else {
                      recordState.startRecording(); // 녹음 시작
                    }
                  },
                ),
                IconButton( // 카메라 녹화 버튼
                  icon: Icon(
                    cameraState.isVideoRecording ? Icons.videocam_off : Icons.videocam,
                    size: 50,
                  ),
                  onPressed: () {
                    if (cameraState.isVideoRecording) {
                      cameraState.stopRecording(); //CanmeraState의 stopRecording() 메서드 호출
                    } else {
                      cameraState.startRecording(); //CanmeraState의 startRecording() 메서드 호출
                    }
                  },
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
  bool recoding_now=true;
}


