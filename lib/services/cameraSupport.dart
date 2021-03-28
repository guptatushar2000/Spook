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
      List output = await FaceDetection(imageFile: imageFile, context: context).getFace();
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
      return output;
    } catch(e) {
      print('error is: ' + e.toString());
      return null;
    }
  }

  // image stream from camera.

}