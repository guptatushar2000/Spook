import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:spook/services/faceDetection.dart';
import 'dart:ui';

class CameraSupport {

  final BuildContext context;
  // CameraDescription cameraDescription;
  // CameraController _cameraController;
  // ImageRotation _cameraRotation;

  CameraSupport({this.context});

  // image clicked using picker
  Future getImageClickedFromCamera() async {
    try {
      PickedFile pickedFile = await ImagePicker().getImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
      File imageFile = File(pickedFile.path);
      List output = await FaceDetection(imageFile: imageFile, context: context).getFace();
      return output;
    } catch(e) {
      print('error is: ' + e.toString());
      return null;
    }
  }

  // image stream from camera.
  // this method is not being used currently.
  Future getImageStreamFromCamera() async {
    try {

      // get the front camera.
      CameraDescription cameraDescription = await getFrontCamera();

      // initialize the camera.
      CameraController cameraController = await initializeCamera(cameraDescription);

      // start streaming images.
      Size imageSize = getImageSize(cameraController);

      cameraController.startImageStream(
          (image) async {
            try {
              bool isVerified = false;
              while(!isVerified) {
                // provide logic for continuously verifying faces.
                isVerified = true;
              }
            } catch(e) {
              print(e.toString());
              return null;
            }
          }
      );
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Asynchronously initialize the front camera for verification.
  Future initializeCamera(CameraDescription description) async {
    try {
      CameraController cameraController = CameraController(
        description,
        ResolutionPreset.high,
        enableAudio: false,
      );
      ImageRotation cameraRotation = rotationIntToImageRotation(description.sensorOrientation);
      await cameraController.initialize();
      return cameraController;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // check the camera orientation.
  ImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return ImageRotation.rotation90;
      case 180:
        return ImageRotation.rotation180;
      case 270:
        return ImageRotation.rotation270;
      default:
        return ImageRotation.rotation0;
    }
  }

  // get the front camera.
  Future getFrontCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    return cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == CameraLensDirection.front,
    );
  }

  // capture image and save it on the given path.
  Future<void> captureImage(String path, CameraController cameraController) async {
    await cameraController.takePicture(path);
  }

  // find the image size.
  Size getImageSize(CameraController cameraController) {
    return Size(
      cameraController.value.previewSize.height,
      cameraController.value.previewSize.width,
    );
  }

  // stop camera and release all resources.
  void dispose(CameraController cameraController) {
    cameraController.dispose();
  }

}