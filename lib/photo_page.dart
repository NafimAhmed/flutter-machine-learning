



import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPage extends StatefulWidget{
  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  late ImagePicker imagePicker;
  File? image;
  late ImageLabeler imageLabeler;
  String imageLabel='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker=ImagePicker();

     ImageLabelerOptions options = ImageLabelerOptions(confidenceThreshold: 0.6);
     imageLabeler = ImageLabeler(options: options);

  }


  Future<void> chooseImage() async {
    XFile? selectedImage=await imagePicker.pickImage(source: ImageSource.gallery);
    if(selectedImage!=null){
      image=File(selectedImage.path);
      setState(() {
        image;
      });
    }
  }


  Future<void> captureImage() async {
    XFile? selectedImage=await imagePicker.pickImage(source: ImageSource.camera);
    if(selectedImage!=null){
      image=File(selectedImage.path);
      performImageLabelling();
      setState(() {
        image;
      });
    }
  }


  performImageLabelling() async {
    InputImage inputImage=InputImage.fromFile(image!);

    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      imageLabel+='+++$text++++\n';
      print('++++++++++++++++++++$text+++++++++++++++++++++++');
    }

    setState(() {
      imageLabel;
    });
  }

  Widget
 build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            image!=null?
            Image.file(image!):Icon(Icons.image_outlined,size: 150,),



            IconButton(onPressed: (){
              // chooseImage();
              captureImage();
            }, icon: Icon(Icons.camera)),

            Text(imageLabel)



          ],
        ),
      ),
    );
  }}