import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:spook/services/faceEncoding.dart';

class FaceDetection {

  final File imageFile;
  final BuildContext context;
  ui.Image image;
  List output;

  FaceEncoding _faceEncoding = FaceEncoding();

  FaceDetection({this.imageFile, this.context});

  Future getFace() async {
    try {
      final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
      final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
        mode: FaceDetectorMode.fast,
        enableLandmarks: true,
        enableTracking: true,
        enableClassification: true,
        enableContours: true,
      ));
      List<Face> faces = await faceDetector.processImage(visionImage);
      print('length: ' + faces.length.toString());
      // for(Face face in faces) {
      //   print(face.smilingProbability);
      // }
      List<Rect> rectArr = [];
      List contourArr = [];
      await _faceEncoding.loadModel();
      for(Face face in faces) {
        print('top: ' + face.boundingBox.top.toString() +
            ', left: ' + face.boundingBox.left.toString() +
            ', bottom: ' + face.boundingBox.bottom.toString() +
            ', right: ' + face.boundingBox.right.toString());
        rectArr.add(face.boundingBox);
        contourArr.add(face.getContour(FaceContourType.face).positionsList);
        output = _faceEncoding.getCurrentPrediction(imageFile, face);
        print('Output Encoding shape: ' + output.length.toString());
        print('Face Encoding: ' + output.toList().toString());
      }
      _faceEncoding.dispose();
      var bytesFromImageFile = imageFile.readAsBytesSync();
      image = await decodeImageFromList(bytesFromImageFile).then((img) {
        return img;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                height: image.height.toDouble(),
                width: image.width.toDouble(),
                child: CustomPaint(
                  painter: Painter(rect: rectArr, contours: contourArr, image: image),
                ),
              ),
            ),
          );
        }
      );
      await Future.delayed(Duration(milliseconds: 1500));
      Navigator.pop(context);
      faceDetector.close();
      return output.isNotEmpty? output: null;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}

class Painter extends CustomPainter {
  final List<Rect> rect;
  final List contours;
  ui.Image image;

  Painter({this.rect, this.contours, this.image});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 17;
    if(image!=null) {
      canvas.drawImage(image, Offset.zero, paint);
    }
    for(var i=0; i<=rect.length-1; i++) {
      canvas.drawRect(rect[i], paint);
    }
    for(var i=0; i<=contours.length-1; i++) {
      canvas.drawPoints(ui.PointMode.points, contours[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}