//mainpage.dart 파일
import 'package:flutter/material.dart'; //플러터 라이브러리
import 'package:provider/provider.dart'; //상태관리 라이브러리
import 'cammer/camera_widget.dart'; // 카메라 위젯(뷰어,녹화버튼)
import 'cammer/camera_state.dart'; //카메라 상태관리, 카메라 함수들 로직
import 'record/audio_record_state.dart'; // 녹음 위젯(녹음버튼)
import 'package:voice_bridge_main/chat/chat_state.dart'; //메세지 모델
import 'package:voice_bridge_main/chat/chat_list_view.dart'; //메세지 리스트뷰
import 'package:flutter_svg/flutter_svg.dart'; //svg 이미지 라이브러리


class Mainpage extends StatefulWidget {
  const Mainpage({super.key});// //생성자

  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  late CameraControlWidget cameraControl; //카메라 녹화 클래스 인스턴스
  List<Message> messages = []; // 메세지 리스트
  bool _isCallbackSet = false;

  @override
  void initState() {//초기화
    super.initState();//부모클래스의 initState 호출
    _loadMessagesFromServer();
    _initializeCallbacks();
  }

  void _initializeCallbacks() {
    // 여기에서 콜백 함수를 설정합니다.
    // 예를 들어, CameraState와 AudioRecordState에서 사용할 콜백 함수를 설정할 수 있습니다.
    final cameraState = Provider.of<CameraRecordState>(context, listen: false);
    final recordState = Provider.of<AudioRecordState>(context, listen: false);

    cameraState.onTextCameraReceived = (text) {
      Provider.of<MessageProvider>(context, listen: false).addMessage(text, true);
    };

    recordState.onTextAudioReceived = (text) {
      Provider.of<MessageProvider>(context, listen: false).addMessage(text, false);
    };
  }

  Future<void> _loadMessagesFromServer() async {
    // Provider를 사용하여 MessageProvider에 접근.
    await Provider.of<MessageProvider>(context, listen: false).getMessagesFromServer();
    // MessageProvider 내부에서 notifyListeners()를 호출하면
    // Provider를 통해 UI가 자동으로 업데이트
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool playing=false;//녹음 중인지 여부
  @override

  Widget build(BuildContext context) { //main페이지 빌드
    // var cameraState = Provider.of<CameraRecordState>(context, listen: true); // 카메라 상태 가져오기
    // // var recordState = Provider.of<AudioRecordState>(context); // 녹음 상태 가져오기
    // var recordState = Provider.of<AudioRecordState>(context, listen: true);
    // // var chatState = Provider.of<MessageProvider>(context, listen: false);
    // if(!_isCallbackSet) {
    //   recordState.onTextAudioReceived = (text) {
    //     Provider.of<MessageProvider>(context, listen: false).addMessage(text, true);
    //   }; // 녹음 중지 후 콜백 함수로 메시지 추가
    //   cameraState.onTextCameraReceived = (text) {
    //     Provider.of<MessageProvider>(context, listen: false).addMessage(text, true);
    //   }; // 카메라 녹화 중지 후 콜백 함수로 메시지 추가
    //   _isCallbackSet = true;
    // }

    // recordState.onTextAudioReceived = (text) {
    //   Provider.of<MessageProvider>(context, listen: false).addMessage(text, true);
    // }; // 녹음 중지 후 콜백 함수로 메시지 추가
    // cameraState.onTextCameraReceived = (text) {
    //   Provider.of<MessageProvider>(context, listen: false).addMessage(text, true);
    // }; // 카메라 녹화 중지 후 콜백 함수로 메시지 추가

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
            Container(
                height: 560,
                width: double.infinity,
                color: Colors.white,
                child: Stack(
                    children: [
                      Positioned.fill(
                        child: CameraView(), // 카메라 뷰를 Stack의 전체 영역에 꽉 차게 배치
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container( // 하단에 초록색 컨테이너를 위치시킴
                            height: 280,
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 33,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.black, // 테두리 색상
                                        width: 2.0, // 테두리 두께
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 3,
                                  child: Center(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          // ListView.builder추가하기
                                          Expanded(child: MessageListView()), // 메세지 리스트뷰
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
                              ],
                            )
                          )
                      ),
                    ]
                )
            ),

            const SizedBox(height: 33),
            Consumer2<AudioRecordState, CameraRecordState>(
              builder: (context, audioRecordState, cameraState, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 70,
                        decoration: BoxDecoration(
                          color: audioRecordState.isRecording ? Colors.grey[600] : Colors.grey[400],
                          borderRadius: BorderRadius.circular(35),
                        ),
                      child: GestureDetector(
                        onTap: () {
                          print("Container tapped!");
                          // 여기에 탭했을 때 수행할 작업을 추가
                          if (audioRecordState.isRecording) {
                            audioRecordState.stopRecording();
                          } else {
                            audioRecordState.startRecording();
                          }
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center, // 가로축을 기준으로 자식들을 중앙에 배치합니다.
                            children: <Widget>[
                                Icon(
                                  audioRecordState.isRecording ? Icons.stop : Icons.mic,
                                  size: 50,
                                ),
                              SizedBox.fromSize(size: Size(6, 0)), //마이크랑 텍스트 간 여백 추가
                              Text(
                                audioRecordState.isRecording ? "OFF" : "ON", //녹음 온오프 텍스트 표시
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),),
                            ],
                          ),
                        ),
                      )
                    ),
                    Container( //카메라버튼
                        width: 150,
                        height: 70,
                        decoration: BoxDecoration(
                          color: cameraState.isVideoRecording ? Colors.green[600] : Colors.green[400],
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            print("Container tapped!");
                            // 여기에 탭했을 때 수행할 작업을 추가
                            if (cameraState.isVideoRecording) {
                              cameraState.stopRecording();
                            } else {
                              cameraState.startRecording();
                            }
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center, // 가로축을 기준으로 자식들을 중앙에 배치합니다.
                              children: <Widget>[
                                Icon(
                                  cameraState.isVideoRecording ? Icons.stop : Icons.videocam,
                                  size: 50,
                                ),
                                SizedBox.fromSize(size: Size(6, 0)), //마이크랑 텍스트 간 여백 추가
                                Text(
                                  cameraState.isVideoRecording ? "OFF" : "ON", //녹음 온오프 텍스트 표시
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),),
                              ],
                            ),
                          ),
                        )
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  bool recoding_now=true;
}


