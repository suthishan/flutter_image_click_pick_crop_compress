
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;

  imageFile(ImageSource source) async {

    var image = await ImagePicker.pickImage(source: source);

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );

    var result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      croppedFile.path,
      quality: 50,
    );

    setState(() {
      _image = result;
      print(_image.lengthSync());
    });
  }


  @override
  Widget build(BuildContext context) {

    print(_image?.lengthSync());


    return Scaffold(
      appBar: AppBar(
        title: Text("Image Pick Crop Compress"),
      ),
      body: Center(
        child: _image == null
            ? Text("Image")
            : Image.file(
                _image,
                height: 200,
                width: 200,
              ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
            label: Text("Camera"),
            onPressed: () => imageFile(ImageSource.camera),
            heroTag: UniqueKey(),
            icon: Icon(Icons.camera),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton.extended(
            label: Text("Gallery"),
            onPressed: () => imageFile(ImageSource.gallery),
            heroTag: UniqueKey(),
            icon: Icon(Icons.photo_library),
          )
        ],
      ),
    );
  }
}