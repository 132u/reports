import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});
  //это свойство нужно,чтоб связать данный виджет с родительским виджетом AuthScreen.
  final void Function(File pickedImage) onPickImage;
  @override
  State<UserImagePicker> createState() {
    return UserImagePickerState();
  }
}

class UserImagePickerState extends State<UserImagePicker> {
    File? _pickedImageFile;
  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150,);
    if(pickedImage==null){
      return;
    }
    setState(() {
    _pickedImageFile =File(pickedImage.path) ;  
    });   
    // В AuthScreen мы передали  _pickedImageFile 
    widget.onPickImage(_pickedImageFile!);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _pickedImageFile != null ? FileImage(_pickedImageFile!): null,
        ),
        TextButton.icon(
          onPressed: pickImage,
          icon: const Icon(Icons.image),
          label: Text(
            'Add image',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        )
      ],
    );
  }
}
