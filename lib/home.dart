import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';


import 'package:flutter/material.dart';import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'main.dart';



class Home extends StatefulWidget{


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late CameraController controller;
  late ImageLabeler imageLabeler;
  bool isBusy=false;
  String result='';

  @override
  void initState() {
    super.initState();


    ImageLabelerOptions options = ImageLabelerOptions(confidenceThreshold: 0.2);
    imageLabeler = ImageLabeler(options: options);


    controller = CameraController(cameras[1], ResolutionPreset.max,imageFormatGroup: Platform.isAndroid
        ? ImageFormatGroup.nv21 // for Android
        : ImageFormatGroup.bgra8888,);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      
      controller.startImageStream((image){

        if(isBusy==false){
          isBusy=true;
          doImageLabeling(image);
        }



        // debugPrint('---------------${image.height}-----${image.width}-----');
      });
      
      setState(() {
        isBusy;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
  }



  doImageLabeling(CameraImage img) async {


    debugPrint('******************Method Called*****************');
    result='';
    InputImage? inputImage = _inputImageFromCameraImage(img);

    if(inputImage!=null){
      final List<ImageLabel> labels = await imageLabeler.processImage(inputImage!);
      for (ImageLabel label in labels) {
        final String text = label.label;
        final int index = label.index;
        final double confidence = label.confidence;

        result+=text+'\n';
        print('++++++++$text++++++++++++++++++');
      }

      setState(() {
        result;
        isBusy=false;
      });

    }



  }

  ////////////////////////////////////////////////////////////////////////

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
    final camera = cameras[1];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
      _orientations[controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }


  ////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [


            CameraPreview(controller),

            Text(result),



          ],
        ),
      ),
    );
  }
}