import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class FaceDetection {

  final File imageFile;
  final BuildContext context;
  ui.Image image;

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
      for(Face face in faces) {
        print('top: ' + face.boundingBox.top.toString() +
            ', left: ' + face.boundingBox.left.toString() +
            ', bottom: ' + face.boundingBox.bottom.toString() +
            ', right: ' + face.boundingBox.right.toString());
        rectArr.add(face.boundingBox);
      }
      var bytesFromImageFile = imageFile.readAsBytesSync();
      print(bytesFromImageFile.length);
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
                  painter: Painter(rect: rectArr, image: image),
                ),
              ),
            ),
          );
        }
      );
      faceDetector.close();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}

class Painter extends CustomPainter {
  final List<Rect> rect;
  ui.Image image;

  Painter({this.rect, this.image});

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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}