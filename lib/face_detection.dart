import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetection extends StatefulWidget {
  FaceDetection({Key? key}) : super(key: key);

  @override
  _FaceDetectionState createState() => _FaceDetectionState();
}

class _FaceDetectionState extends State<FaceDetection> {
  late ImagePicker imagePicker;
  File? _image;
  String result = '';
  dynamic faceDetector;

  dynamic image;
  late List<Face> faces;

  //TODO declare detector

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
    //TODO initialize detector

    final options = FaceDetectorOptions(
      enableLandmarks: true,
      enableClassification: true,
      enableContours: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.fast,
    );
     faceDetector = FaceDetector(options: options);
  }

  @override
  void dispose() {
    super.dispose();
  }

  //TODO capture image using camera
  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      doFaceDetection();
    }
  }

  //TODO choose image using gallery
  _imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      doFaceDetection();
    }
  }

  //TODO face detection code here
  doFaceDetection() async {
    result = "";
    InputImage inputImage = InputImage.fromFile(_image!);


      faces = await faceDetector.processImage(inputImage);


    print('************Len : ${faces.length}**********************');

    // for (Face face in faces) {
    //   final Rect boundingBox = face.boundingBox;
    //
    //   final double? rotX = face.headEulerAngleX; // Head is tilted up and down rotX degrees
    //   final double? rotY = face.headEulerAngleY; // Head is rotated to the right rotY degrees
    //   final double? rotZ = face.headEulerAngleZ; // Head is tilted sideways rotZ degrees
    //
    //   // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
    //   // eyes, cheeks, and nose available):
    //   final FaceLandmark? leftEar = face.landmarks[FaceLandmarkType.leftEar];
    //   if (leftEar != null) {
    //     final Point<int> leftEarPos = leftEar.position;
    //   }
    //
    //   // If classification was enabled with FaceDetectorOptions:
    //   if (face.smilingProbability != null) {
    //     final double? smileProb = face.smilingProbability;
    //   }
    //
    //   // If face tracking was enabled with FaceDetectorOptions:
    //   if (face.trackingId != null) {
    //     final int? id = face.trackingId;
    //   }
    // }


    setState(() {
      _image;
    });
     drawRectangleAroundFaces();
  }

  // //TODO draw rectangles
  drawRectangleAroundFaces() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    setState(() {
      image;
      result;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/bg.jpg'), fit: BoxFit.cover),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 100,
          ),
          Container(
            margin: const EdgeInsets.only(top: 100),
            child: Stack(children: <Widget>[
              Center(
                child: ElevatedButton(
                  onPressed: _imgFromGallery,
                  onLongPress: _imgFromCamera,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent),
                  child:



                  // Container(
                  //   margin: const EdgeInsets.only(top: 8),
                  //   child: _image != null
                  //       ? Image.file(
                  //           _image!,
                  //           width: 335,
                  //           height: 495,
                  //           fit: BoxFit.fill,
                  //         )
                  //       : Container(
                  //           width: 340,
                  //           height: 330,
                  //           color: Colors.black,
                  //           child: const Icon(
                  //             Icons.camera_alt,
                  //             color: Colors.white,
                  //             size: 100,
                  //           ),
                  //         ),
                  // ),
                  //



                  Container(
                    width: 335,
                    height: 495,
                    margin: const EdgeInsets.only(
                      top: 45,
                    ),
                    child: image != null
                        ? Center(
                            child: FittedBox(
                              child: SizedBox(
                                width: image.width.toDouble(),
                                height: image.width.toDouble(),
                                child: CustomPaint(
                                  painter: FacePainter(
                                      facesList: faces, imageFile: image),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.black,
                            width: 340,
                            height: 330,
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                  ),






                ),
              ),
            ]),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Text(
              result,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 36, color: Colors.green),
            ),
          ),
        ],
      ),
    ));
  }
}


class FacePainter extends CustomPainter {
  List<Face> facesList;
  dynamic imageFile;
  FacePainter({required this.facesList, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }
    Paint p = Paint();
    p.color = Colors.green;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 10;

    for (Face rectangle in facesList) {
      canvas.drawRect(rectangle.boundingBox, p);
    }

    // Paint p2 = Paint();
    // p2.color = Colors.green;
    // p2.style = PaintingStyle.stroke;
    // p2.strokeWidth = 1;
    //
    // Paint p3 = Paint();
    // p3.color = Colors.yellow;
    // p3.style = PaintingStyle.stroke;
    // p3.strokeWidth = 1;
    //
    // for (Face face in facesList) {
    //   Map<FaceContourType, FaceContour?> con = face.contours;
    //   List<Offset> offsetPoints = <Offset>[];
    //   con.forEach((key, value) {
    //     if(value != null) {
    //       List<Point<int>>? points = value.points;
    //       for (Point p in points) {
    //         Offset offset = Offset(p.x.toDouble(), p.y.toDouble());
    //         offsetPoints.add(offset);
    //       }
    //       canvas.drawPoints(PointMode.points, offsetPoints, p2);
    //     }
    //   });
    //
    //   // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
    //   // eyes, cheeks, and nose available):
    //   final FaceLandmark leftEar = face.landmarks[FaceLandmarkType.leftEar]!;
    //   if (leftEar != null) {
    //     final Point<int> leftEarPos = leftEar.position;
    //     canvas.drawRect(Rect.fromLTWH(leftEarPos.x.toDouble()-5, leftEarPos.y.toDouble()-5,10,10),  p3);
    //   }
    //
    // }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
