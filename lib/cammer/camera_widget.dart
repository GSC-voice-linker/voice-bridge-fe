import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
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
    var cameraState = Provider.of<CameraState>(context);

    if (!cameraState.isCameraInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: cameraState.cameraController!.value.aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: cameraState.isVideoRecording ? Colors.green : Colors.transparent, // 녹화 중일 때는 초록색 테두리
            width: 3, // 테두리 두께
          ),
        ),
        child: CameraPreview(cameraState.cameraController!),
      ),
    );
  }
}
//카메라 버튼
class CameraControlWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cameraState = Provider.of<CameraState>(context, listen: false);

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



