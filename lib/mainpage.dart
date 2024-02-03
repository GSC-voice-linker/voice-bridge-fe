//mainpage.dart 파일
import 'package:flutter/material.dart'; //플러터 라이브러리
import 'package:provider/provider.dart'; //상태관리 라이브러리
import 'cammer/camera_widget.dart'; // 카메라 위젯(뷰어,녹화버튼)
import 'cammer/camera_state.dart'; //카메라 상태관리, 카메라 함수들 로직
import 'record/audio_record_state.dart'; // 녹음 위젯(녹음버튼)
import 'package:voice_bridge_main/chat/chat_state.dart'; //메세지 모델
import 'package:voice_bridge_main/chat/chat_list_view.dart'; //메세지 리스트뷰
import 'package:voice_bridge_main/chat/chat_service.dart'; //메세지 버블
import 'package:flutter_svg/flutter_svg.dart'; //svg 이미지 라이브러리

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});//

  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  // late final AudioRecorder audioRecord; //Record 클래스 인스턴스
  // late AudioPlayer audioPlayer;
  // bool isAudioRecording = false; // 녹음 중인지 여부를 저장하는 변수]
  // String audioPath = ""; // 녹음된 파일의 경로를 저장하는 변수 .state파일에서 관리함으로 제거
  late CameraControlWidget cameraControl; //카메라 녹화 클래스 인스턴스
  List<Message> messages = []; // 메세지 리스트


  @override
  void initState() {//초기화
    super.initState();//부모클래스의 initState 호출
    _loadMessages(); // 메세지 불러오기
  }

  Future<void> _loadMessages() async {
    // 메시지를 불러오는 로직 (임시 데이터 사용)
    messages = await MessageService.getMessages();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool playing=false;//녹음 중인지 여부
  @override

  Widget build(BuildContext context) { //main페이지 빌드
    var cameraState = Provider.of<CameraState>(context); // 카메라 상태 가져오기
    var recordState = Provider.of<AudioRecordState>(context); // 녹음 상태 가져오기


    return Scaffold(
      appBar: AppBar(
        title: const Text('VOICE BRIDGE'),
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/voice.svg'), // 메뉴 아이콘
          onPressed: () {
            // Handle menu action
          },
        ),
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
                width: MediaQuery.of(context).size.width * 0.6, //좌우의 50퍼센트만씀
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
                  child: Column(
                    children: <Widget>[
                      // ListView.builder추가하기
                      Expanded(child: MessageListView(messages: messages)), // 메세지 리스트뷰
                    ],
                  ),
                  // 채팅 화면 컨테이너 스타일 설정
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
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


