import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image/image.dart' as img;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File pickedImage;
  var imageFile;
  List<Rect> rect = new List<Rect>();

  bool isFaceDetected = false;

  Future pickImage() async {
    var awaitImage = await ImagePicker.pickImage(source: ImageSource.camera);

    imageFile = await awaitImage.readAsBytes();
    imageFile = await decodeImageFromList(imageFile);

    setState(() {
      imageFile = imageFile;
      pickedImage = awaitImage;
    });
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);

    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();

    final List<Face> faces = await faceDetector.processImage(visionImage);
    if (rect.length > 0) {
      rect = new List<Rect>();
    }
    for (Face face in faces) {
      rect.add(face.boundingBox);

      final double rotY =
          face.headEulerAngleY; // Head is rotated to the right rotY degrees
      final double rotZ =
          face.headEulerAngleZ; // Head is tilted sideways rotZ degrees
      print('the rotation y is ' + rotY.toStringAsFixed(2));
      print('the rotation z is ' + rotZ.toStringAsFixed(2));
    }

    setState(() {
      isFaceDetected = true;
    });

    // Cropping face from image
    List<Map<String, int>> faceMaps = [];
    for (Face face in faces) {
      int x = face.boundingBox.left.toInt();
      int y = face.boundingBox.top.toInt();
      int w = face.boundingBox.width.toInt();
      int h = face.boundingBox.height.toInt();
      Map<String, int> thisMap = {'x': x, 'y': y, 'w': w, 'h':h};
      faceMaps.add(thisMap);

      // create an img.Image from your original image file for processing
      img.Image originalImage = img.decodeImage(File(imageFile.path).readAsBytesSync());
      // now crop out only the detected face boundry, below will crop out the first face from the list
      img.Image faceCrop = img.copyCrop(originalImage, faceMaps[0]['x'], faceMaps[0]['y'], faceMaps[0]['w'], faceMaps[0]['h']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 50.0),
          isFaceDetected
              ? Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(blurRadius: 20),
                ],
              ),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: FittedBox(
                child: SizedBox(
                  width: imageFile.width.toDouble(),
                  height: imageFile.height.toDouble(),
                  child: CustomPaint(
                    painter:
                    FacePainter(rect: rect, imageFile: imageFile),
                  ),
                ),
              ),
            ),
          )
              : Container(),
          Center(
            child: FlatButton.icon(
              icon: Icon(
                Icons.photo_camera,
                size: 100,
              ),
              label: Text(''),
              textColor: Theme.of(context).primaryColor,
              onPressed: () async {
                pickImage();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  List<Rect> rect;
  var imageFile;

  FacePainter({@required this.rect, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    for (Rect rectangle in rect) {
      canvas.drawRect(
        rectangle,
        Paint()
          ..color = Colors.teal
          ..strokeWidth = 6.0
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}