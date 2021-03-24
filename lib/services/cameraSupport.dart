import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spook/services/faceDetection.dart';

class CameraSupport {

  final BuildContext context;

  CameraSupport({this.context});

  // image clicked using picker
  Future getImageClickedFromCamera() async {
    try {
      PickedFile pickedFile = await ImagePicker().getImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
      File imageFile = File(pickedFile.path);
      await FaceDetection(imageFile: imageFile, context: context).getFace();
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       content: Image.file(
      //         imageFile,
      //         fit: BoxFit.cover,
      //       ),
      //     );
      //   }
      // );
      return true;
    } catch(e) {
      print('error is: ' + e.toString());
      return false;
    }
  }

  // image stream from camera.

}