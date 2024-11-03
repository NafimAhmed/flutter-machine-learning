


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class BarCodeScanner extends StatefulWidget{


  @override
  State<BarCodeScanner> createState() => _BarCodeScannerState();
}

class _BarCodeScannerState extends State<BarCodeScanner> {
  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    _image = File(pickedFile!.path);
    setState(() {
      _image;
      doBarcodeScanning();
    });
  }

  //TODO choose image using gallery
  _imgFromGallery() async {
    XFile? pickedFile =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doBarcodeScanning();
      });
    }
  }

  doBarcodeScanning() async {

    print('****************$result***********');

    InputImage inputImage=InputImage.fromFile(_image!);


     List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);

     result='${barcodes.first.value}';

    print('****************${barcodes.first.value}***********');

    for (Barcode barcode in barcodes) {
       BarcodeType type = barcode.type;
       Rect boundingBox = barcode.boundingBox;
       String? displayValue = barcode.displayValue;
       String? rawValue = barcode.rawValue;


      result='${barcode.value}' ;

      print('****************$result***********');

      // See API reference for complete list of supported types
      switch (type) {
        case BarcodeType.wifi:
          BarcodeWifi barcodeWifi = barcode.value as BarcodeWifi;

            result='WIFI : ${barcodeWifi}';

          break;
        case BarcodeType.url:
          BarcodeUrl barcodeUrl = barcode.value as BarcodeUrl;


            result='URL : ${barcodeUrl}';

          break;
        case BarcodeType.unknown:
          // TODO: Handle this case.
        case BarcodeType.contactInfo:
          // TODO: Handle this case.
        case BarcodeType.email:
          // TODO: Handle this case.
        case BarcodeType.isbn:
          // TODO: Handle this case.
        case BarcodeType.phone:
          // TODO: Handle this case.
        case BarcodeType.product:
          // TODO: Handle this case.
        case BarcodeType.sms:
          // TODO: Handle this case.
        case BarcodeType.text:
          // TODO: Handle this case.
        case BarcodeType.geoCoordinates:
          // TODO: Handle this case.
        case BarcodeType.calendarEvent:
          // TODO: Handle this case.
        case BarcodeType.driverLicense:
          // TODO: Handle this case.
      }


      setState(() {
        result;

        print('****************$result***********');
      });

    }

  }



  late ImagePicker imagePicker;
  File? _image;
  String result = 'results will be shown here';

  dynamic barcodeScanner;

  //TODO declare scanner

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
    //TODO initialize scanner
     List<BarcodeFormat> formats = [BarcodeFormat.all];
     barcodeScanner = BarcodeScanner(formats: formats);

  }

  @override
  void dispose() {
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/bg.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        body:  SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                width: 100,
              ),
              Container(
                margin: const EdgeInsets.only(top: 100),
                child: Stack(children: <Widget>[
                  Stack(children: <Widget>[
                    Center(
                      child: Image.asset(
                        'images/frame.jpg',
                        height: 350,
                        width: 350,
                      ),
                    ),
                  ]),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,backgroundColor: Colors.transparent),
                      onPressed: _imgFromGallery,
                      onLongPress: _imgFromCamera,
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: _image != null
                            ? Image.file(
                          _image!,
                          width: 325,
                          height: 325,
                          fit: BoxFit.fill,
                        )
                            : Container(
                          width: 340,
                          height: 330,
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 100,
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
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}