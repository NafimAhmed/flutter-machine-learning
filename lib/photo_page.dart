



import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPage extends StatefulWidget{
  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  late ImagePicker imagePicker;
  File? image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker=ImagePicker();

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

  Widget
 build(BuildContext context){
    return Scaffold(
      body: Column(
        children: [

          image!=null?
          Image.file(image!):Icon(Icons.image_outlined,size: 150,),



          IconButton(onPressed: (){
            chooseImage();
          }, icon: Icon(Icons.camera))



        ],
      ),
    );
  }}