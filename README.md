# VoiceBridge Frontend Setup Guide

VoiceBridge revolutionizes communication between the deaf and hearing communities through a Flutter-based application, ensuring seamless real-time interactions. This guide walks you through setting up the project in Android Studio, including dependency installation, emulator setup, and app execution.

## Initial Settings

Prerequisites: Ensure Flutter SDK and Android Studio are installed.
Project Cloning: Open Android Studio, select "Open an Existing Project," and navigate to the VoiceBridge project directory.
Dependency Installation
Open the integrated terminal within Android Studio and execute flutter pub get to install project dependencies, ensuring the project is correctly configured with all necessary Flutter packages.
```
Flutter pub get
```

For the README file in your project, here's a tailored description based on the provided details:

---

## Environment Variable Configuration

Our project utilizes a `.env` file to manage server addresses and other sensitive configurations. For a seamless experience in running the project on your machine, you're required to set up a `.env` file in the root directory of the project. This file should include necessary configurations, prominently the server addresses essential for the application's operation.

### Creating the .env File

1. Navigate to the project's root directory.
2. Create a new file named `.env`.
3. Add your configuration details in the format shown below:

For security reasons, we have not provided the direct URLs to our server in the configuration. However, the server is operational, so you should be able to use the application without any issues by installing the APK.

```plaintext
appSttKey='Sever Url'
appSignTranslationKey='Sever Url'
```

Ensure that the `.env` file follows the correct format and includes all required configurations to ensure the application functions as intended in your development environment.

---

## Emulator Settings

Utilize Android Studio's AVD Manager to launch an emulator or connect an Android device for testing. Select your preferred device for app deployment.
For the best development experience, it is recommended to use the Pixel 4 API 34 version in the Android Emulator. This setup mirrors the app's development environment closely, ensuring a smoother emulation of its features.

## Enable camera function

To accurately test and use the camera features integral to VoiceBridge:
1. Direct Device Connection: Connect an Android phone to your development machine and enable USB debugging mode.
2. Debug Mode Execution: Run the application in debug mode on the connected device to access the camera hardware directly.

## Running an Application

Deploy VoiceBridge by clicking the 'Run' button in Android Studio or executing flutter run in the terminal. This command compiles the project and launches it on the chosen device or emulator, bringing the application to life for testing or development purposes.

## How to resolve the issue

Encountered issues, such as SDK path errors or dependency conflicts, can often be resolved by verifying Flutter SDK settings under 'File > Project Structure > Project' or running flutter clean followed by flutter pub get to refresh project dependencies.
