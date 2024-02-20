import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_state.dart';
import 'package:provider/provider.dart';
//카메라 뷰어
class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  @override
  Widget build(BuildContext context) {
    var cameraState = Provider.of<CameraRecordState>(context);

    if (!cameraState.isCameraInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    final cameraAspectRatio = cameraState.cameraController!.value.aspectRatio;

    return Container(
      width: double.infinity,
      height: 600,
      decoration: BoxDecoration(

        // 여기서 테두리 색상과 둥근 모서리를 설정합니다.
        border: Border.all(
          color: Colors.black, // 테두리 색상 설정
          width: 0.8, // 테두리 두께 설정
        ),
        borderRadius: BorderRadius.circular(20), // 둥근 모서리의 반지름 설정
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // ClipRRect와 Container의 borderRadius를 일치시킵니다.
        child: AspectRatio(
          aspectRatio: cameraAspectRatio,
          child: CameraPreview(cameraState.cameraController!),
        ),
      ),
    );
  }
}

//카메라 버튼
class CameraControlWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cameraState = Provider.of<CameraRecordState>(context, listen: false);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(
              cameraState.isVideoRecording ? Icons.videocam_off : Icons.videocam,
              color: Colors.red,
              size: 50,
            ),
            onPressed: () {
              if (cameraState.isVideoRecording) {
                cameraState.stopRecording();
              } else {
                cameraState.startRecording();
              }
            },
          )
        ],
      ),
    );
  }
}



