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
    // _loadMessagesFromServer();
    _initializeCallbacks();
  }
  void _initializeCallbacks() {
    // 여기에서 콜백 함수를 설정합니다.
    final cameraState = Provider.of<CameraRecordState>(context, listen: false); // 카메라 상태 가져오기
    final recordState = Provider.of<AudioRecordState>(context, listen: false); // 녹음 상태 가져오기

    // 녹화 시작 시 임시 메시지 추가 로직
    cameraState.onStartRecording = () {
      // 비디오 녹화 시작 시 임시 메시지 추가하고, 임시 메시지의 ID를 저장합니다.
      String tempVideoMessageId = Provider.of<MessageProvider>(context, listen: false).addTemporaryMessage(isAudio: false);
      cameraState.tempVideoMessageId = tempVideoMessageId; // 카메라 상태에 임시 메시지 ID 저장
    };

    cameraState.onTextCameraReceived = (text) {
      // '녹화중...' 메시지가 추가된 상태에서 텍스트를 받으면, 해당 메시지를 실제 텍스트로 업데이트
      if(cameraState.tempVideoMessageId != null) {
        Provider.of<MessageProvider>(context, listen: false).updateMessage(cameraState.tempVideoMessageId!, text,true);
      }
    };

    // 녹음 시작 시 임시 메시지 추가 로직
    recordState.onStartRecording = () {
      // 오디오 녹음 시작 시 임시 메시지 추가하고, 임시 메시지의 ID를 저장합니다.
      String tempAudioMessageId = Provider.of<MessageProvider>(context, listen: false).addTemporaryMessage(isAudio: true);
      recordState.tempAudioMessageId = tempAudioMessageId; // 녹음 상태에 임시 메시지 ID 저장
    };

    recordState.onTextAudioReceived = (text) {
      // '음성 녹음 중...' 메시지가 추가된 상태에서 텍스트를 받으면, 해당 메시지를 실제 텍스트로 업데이트
      if(recordState.tempAudioMessageId != null) {
        Provider.of<MessageProvider>(context, listen: false).updateMessage(recordState.tempAudioMessageId!, text, false);
      }
    };
  }

  //
  // Future<void> _loadMessagesFromServer() async { // 서버로부터 메시지를 가져오는 함수
  //   // Provider를 사용하여 MessageProvider에 접근.
  //   await Provider.of<MessageProvider>(context, listen: false).getMessagesFromServer(); // 서버로부터 메시지 가져오기
  //   // MessageProvider 내부에서 notifyListeners()를 호출하면
  //   // Provider를 통해 UI가 자동으로 업데이트
  // }

  @override
  void dispose() {
    super.dispose();
  }

  bool playing=false;//녹음 중인지 여부
  @override

  Widget build(BuildContext context) { //main페이지 빌드
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'VOICE BRIDGE',
            style: TextStyle(fontFamily: 'OnlyAppbar',
            fontWeight: FontWeight.w700,
            fontSize: 24,),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 20), // 왼쪽 여백을 20으로 설정
          child: Image.asset(
            'assets/icons/image_1-removebg-preview 2.png',
            width: 50, // 이미지의 폭을 적절히 조정하세요
            height: AppBar().preferredSize.height, // AppBar의 높이에 맞춰 이미지 높이 조정
            fit: BoxFit.scaleDown, // 비율을 유지하면서 컨테이너에 맞게 이미지 조정
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10), //

            child: IconButton(
              icon: const Icon(Icons.help_outline, color: Color(0xff5290DB), size: 30,),
              onPressed: () {
                // Handle help action
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
                height: 620,
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
                                Container( //채팅위에 가리기용
                                  height: 24,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.black, // 테두리 색상
                                        width: 0.8, // 테두리 두께
                                      ),
                                    ),

                                  ),
                                ),
                                Expanded(
                                  flex: 1,
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
                                        color: Color(0xffF2F2F2),//채팅배경
                                        border: Border.all(color: Colors.black, width: 0.8), // 테두리 설정
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
//-------- 여기부터 버튼
            const SizedBox(height:30),
            Consumer2<AudioRecordState, CameraRecordState>(
              builder: (context, audioRecordState, cameraState, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 140,
                      height: 60,
                        decoration: BoxDecoration( //녹음버튼
                          color: audioRecordState.isAudioRecording ? Color(0xff8D8D8D) : Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(35),
                        ),
                      child: GestureDetector(
                        onTap: () {
                          print("Container tapped!");
                          // 여기에 탭했을 때 수행할 작업을 추가
                          if (audioRecordState.isAudioRecording==true && cameraState.isVideoRecording==false) {
                            audioRecordState.stopRecording();
                          } else if(audioRecordState.isAudioRecording==false && cameraState.isVideoRecording==false){
                            audioRecordState.startRecording();
                          }
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center, // 가로축을 기준으로 자식들을 중앙에 배치합니다.
                            children: <Widget>[
                                Icon(
                                  audioRecordState.isAudioRecording ? Icons.stop : Icons.mic,
                                  size: 35,
                                  color: audioRecordState.isAudioRecording ? Colors.white : Colors.black,
                                ),
                              SizedBox.fromSize(size: Size(6, 0)), //마이크랑 텍스트 간 여백 추가
                              Text(
                                audioRecordState.isAudioRecording ? "OFF" : "ON", //녹음 온오프 텍스트 표시
                                style: TextStyle(
                                  fontFamily: 'OnlyAppbar',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25,
                                  color: audioRecordState.isAudioRecording ? Colors.white : Colors.black,
                                ),),
                            ],
                          ),
                        ),
                      )
                    ),
                    Container( //카메라버튼
                        width: 140,
                        height: 60,
                        decoration: BoxDecoration(
                          color: cameraState.isVideoRecording ?  Color(0xff3FA737) : Color(0xff8BD985), //녹화중일때 색상 왼쪽이 진한거
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            print("녹화버튼눌림!+++++++++++++++++++++++++++++++++++++++");
                            // 여기에 탭했을 때 수행할 작업을 추가
                            if (cameraState.isVideoRecording==true && audioRecordState.isAudioRecording==false) {
                              cameraState.stopRecording();
                              print("녹화버튼안 녹화 중지 로직!+++++++++++++++++++++++++++++++++++++++");
                            } else if(cameraState.isVideoRecording==false && audioRecordState.isAudioRecording==false){
                              cameraState.startRecording();
                              print("녹화버튼안 녹화 시작 로직!+++++++++++++++++++++++++++++++++++++++");
                            }
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center, // 가로축을 기준으로 자식들을 중앙에 배치합니다.
                              children: <Widget>[
                                Icon(
                                  cameraState.isVideoRecording ? Icons.stop : Icons.pan_tool,
                                  size: 30,
                                  color: cameraState.isVideoRecording ? Colors.white : Colors.black,
                                ),
                                SizedBox.fromSize(size: Size(10, 0)), //손이랑 텍스트 간 여백 추가
                                Text(
                                  cameraState.isVideoRecording ? "OFF" : "ON", //녹화 온오프 텍스트 표시
                                  style: TextStyle(
                                    fontFamily: 'OnlyAppbar',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                    color: cameraState.isVideoRecording ? Colors.white : Colors.black,
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


