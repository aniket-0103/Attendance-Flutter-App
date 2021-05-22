import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:image_cropper/image_cropper.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image/image.dart' as img;


class Tensorflow extends StatefulWidget {
  @override
  _TensorflowState createState() => _TensorflowState();
}

class _TensorflowState extends State<Tensorflow> {
  String name;
  List _outputs;
  File val;
  File _image;
  bool _loading = false;
  var imageFile;
  List<Rect> rect = new List<Rect>();

  bool isFaceDetected = false;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
    );
  }
  classifyImage(File image) async {

    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 117.5,
        imageStd: 117.5,
        numResults: 3,
        threshold: 0.8,
        asynch: true
    );
    setState(() {
      _loading = false;
      _outputs = output as List;
      name = _outputs[0]["label"];
      print(name);
    });
  }
  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
  pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    // imageFile = await image.readAsBytes();
    // imageFile = await decodeImageFromList(imageFile);

    // setState(() {
    //   imageFile = imageFile;
    //   _image = image;
    // });
    // FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(_image);
    //
    // final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
    //
    // final List<Face> faces = await faceDetector.processImage(visionImage);
    // if (rect.length > 0) {
    //   rect = new List<Rect>();
    // }
    // for (Face face in faces) {
    //   rect.add(face.boundingBox);
    //
    //   final double rotY =
    //       face.headEulerAngleY; // Head is rotated to the right rotY degrees
    //   final double rotZ =
    //       face.headEulerAngleZ; // Head is tilted sideways rotZ degrees
    //   print('the rotation y is ' + rotY.toStringAsFixed(2));
    //   print('the rotation z is ' + rotZ.toStringAsFixed(2));
    // }
    //
    // setState(() {
    //   isFaceDetected = true;
    // });
    //
    // // Cropping face from image
    // List<Map<String, int>> faceMaps = [];
    // for (Face face in faces) {
    //   int x = face.boundingBox.left.toInt();
    //   int y = face.boundingBox.top.toInt();
    //   int w = face.boundingBox.width.toInt();
    //   int h = face.boundingBox.height.toInt();
    //   Map<String, int> thisMap = {'x': x, 'y': y, 'w': w, 'h':h};
    //   faceMaps.add(thisMap);
    //
    //   // create an img.Image from your original image file for processing
    //   img.Image originalImage = img.decodeImage(File(imageFile.path).readAsBytesSync());
    //   // now crop out only the detected face boundry, below will crop out the first face from the list
    //   img.Image faceCrop = img.copyCrop(originalImage, faceMaps[0]['x'], faceMaps[0]['y'], faceMaps[0]['w'], faceMaps[0]['h']);

    setState(() {
      _loading = true;
      _image = image;
    });
    print(image);
    _image = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      maxHeight: 700,
      maxWidth: 700,
      compressFormat: ImageCompressFormat.jpg,
    );
    print("cropper ${val.runtimeType}");
    classifyImage(_image);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Tensorflow Lite",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _loading ? Container(
              height: 300,
              width: 300,
            ):
            Container(
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _image == null ? Container() : Image.file(_image),
                  SizedBox(
                    height: 20,
                  ),
                  _image == null ? Container() : _outputs != null ?
                  Text(_outputs[0]["label"],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20
                    ),
                  ) : Container(child: Text(""))
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            FloatingActionButton(
              tooltip: 'Pick Image',
              onPressed: pickImage,
              child: Icon(Icons.add_a_photo,
                size: 20,
                color: Colors.white,
              ),
              backgroundColor: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}

