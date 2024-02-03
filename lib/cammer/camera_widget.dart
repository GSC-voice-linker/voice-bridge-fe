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
    var cameraState = Provider.of<CameraRecordState>(context);

    if (!cameraState.isCameraInitialized) {
      return Center(child: CircularProgressIndicator());
    }
// 원하는 출력 비율을 설정합니다. 예: 3:4
    final desiredAspectRatio = 11 / 20;
    // 실제 카메라 비율을 가져옵니다.
    final cameraAspectRatio = cameraState.cameraController!.value.aspectRatio;
    // 카메라 프리뷰의 실제 크기 비율을 계산합니다.
    final actualPreviewWidth = MediaQuery.of(context).size.width * 0.9; // 카메라 프리뷰의 너비
    final actualPreviewHeight = actualPreviewWidth * desiredAspectRatio; // 카메라 프리뷰의 높이

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: actualPreviewWidth,
        height: actualPreviewHeight,
        child: OverflowBox(
          // OverflowBox를 사용하여 카메라 프리뷰가 원하는 비율을 넘어서도록 허용합니다.
          // 이렇게 하면 가운데 부분만 화면에 표시됩니다.
          maxWidth: actualPreviewWidth, // 최대 너비
          maxHeight: actualPreviewWidth / cameraAspectRatio, // 최대 높이
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



