import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';

class UploadingImageToFirebaseStorage extends StatefulWidget {
  @override
  _UploadingImageToFirebaseStorageState createState() =>
      _UploadingImageToFirebaseStorageState();
}

class _UploadingImageToFirebaseStorageState
    extends State<UploadingImageToFirebaseStorage> {
  late File _imageFile;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    UploadTask uploadTask;
    String fileName = basename(_imageFile.path);
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': _imageFile.path},
    );
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('flutter-tests')
        .child('/some-image.jpg');
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);

    try {
      uploadTask = ref.putData(await file!.readAsBytes(), metadata);
    } catch (e) {
      print(e);
      try {
        uploadTask = ref.putFile(File(file!.path), metadata);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
