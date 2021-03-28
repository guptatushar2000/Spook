import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart' as tflite;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image/image.dart' as imglib;
import 'dart:io';

class FaceEncoding {

  // singleton boilerplate.
  static final FaceEncoding _faceEncoding = FaceEncoding._internal();

  factory FaceEncoding() {
    return _faceEncoding;
  }

  // singleton boilerplate.
  FaceEncoding._internal();

  tflite.Interpreter _interpreter;

  // List _predictedData;
  // List get predictedData => this._predictedData;

  // saved users data.
  dynamic data = {};

  void dispose() {
    _interpreter.close();
    print('all resources released!');
  }

  // load the model.
  Future loadModel() async {
    try{
      final gpuDelegateV2 = tflite.GpuDelegateV2(
        options: tflite.GpuDelegateOptionsV2(
          false,
          tflite.TfLiteGpuInferenceUsage.fastSingleAnswer,
          tflite.TfLiteGpuInferencePriority.minLatency,
          tflite.TfLiteGpuInferencePriority.auto,
          tflite.TfLiteGpuInferencePriority.auto,
        )
      );
      var interpreterOptions = tflite.InterpreterOptions()..addDelegate(gpuDelegateV2);
      this._interpreter = await tflite.Interpreter.fromAsset('mobilefacenet2.tflite', options: interpreterOptions);
      print('model loaded successfully!');
    } catch(e) {
      print('error loading model: ' + e.toString());
    }
  }

  getCurrentPrediction(File imageFile, Face face) {
    // crop the face.
    List input = _preProcess(imageFile, face);

    // reshape image to correct input dimension.
    input = input.reshape([1, 112, 112, 3]);
    List output = List(1 * 192).reshape([1, 192]);

    // run the model and transform the image to encoding.
    this._interpreter.run(input, output);
    output = output.reshape([192]);

    // this._predictedData = List.from(output);
    return output;
  }

  // preProcess the image.
  List _preProcess(File imageFile, Face faceDetected) {
    // crop the face.
    imglib.Image croppedImage = _cropFace(imageFile, faceDetected);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);

    // transform the cropped image to array.
    Float32List imageAsList = imageToByteListFloat32(img);
    return imageAsList;
  }

  // crop the face from image.
  _cropFace(File imageFile, Face faceDetected) {
    // convert image to image.Image format for processing.
    imglib.Image convertedImage = imglib.decodeImage(File(imageFile.path).readAsBytesSync());
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(convertedImage, x.round(), y.round(), w.round(), h.round());
  }

  Float32List imageToByteListFloat32(imglib.Image image) {
    // input size is 112.
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for(int i=0; i<112; ++i) {
      for(int j=0; j<112; ++j) {
        var pixel = image.getPixel(j, i);

        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }
}