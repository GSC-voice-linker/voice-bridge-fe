# VoiceBridge Frontend Setup Guide

VoiceBridge revolutionizes communication between the deaf and hearing communities through a Flutter-based application, ensuring seamless real-time interactions. This guide walks you through setting up the project in Android Studio, including dependency installation, emulator setup, and app execution.

## 초기 설정

Prerequisites: Ensure Flutter SDK and Android Studio are installed.
Project Cloning: Open Android Studio, select "Open an Existing Project," and navigate to the VoiceBridge project directory.
Dependency Installation
Open the integrated terminal within Android Studio and execute flutter pub get to install project dependencies, ensuring the project is correctly configured with all necessary Flutter packages.
```
퍼덕퍼덕 퍼덕퍼덕
```

## 에뮬레이터 설정

Utilize Android Studio's AVD Manager to launch an emulator or connect an Android device for testing. Select your preferred device for app deployment.
For the best development experience, it is recommended to use the Pixel 4 API 34 version in the Android Emulator. This setup mirrors the app's development environment closely, ensuring a smoother emulation of its features.

## 카메라 기능 활성화

To accurately test and use the camera features integral to VoiceBridge:
1. Direct Device Connection: Connect an Android phone to your development machine and enable USB debugging mode.
2. Debug Mode Execution: Run the application in debug mode on the connected device to access the camera hardware directly.

## 응용 프로그램 실행

Deploy VoiceBridge by clicking the 'Run' button in Android Studio or executing flutter run in the terminal. This command compiles the project and launches it on the chosen device or emulator, bringing the application to life for testing or development purposes.

## 문제 해결

Encountered issues, such as SDK path errors or dependency conflicts, can often be resolved by verifying Flutter SDK settings under 'File > Project Structure > Project' or running flutter clean followed by flutter pub get to refresh project dependencies.
