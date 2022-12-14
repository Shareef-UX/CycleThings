import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:getwidget/getwidget.dart';

class GoodsImagePicker extends StatefulWidget {
  // const GoodsImagePicker({Key? key}) : super(key: key);
  GoodsImagePicker(this.imagePickFn, this.imageUrl);

  final void Function(File pickedImage) imagePickFn;
  final String imageUrl;

  @override
  State<GoodsImagePicker> createState() => _GoodsImagePickerState();
}

class _GoodsImagePickerState extends State<GoodsImagePicker> {
  String imageUrl;

  File _pickedImage;

  void _pickImages() async {
    final pickedimagefile = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _pickedImage = pickedimagefile;
    });
    widget.imagePickFn(pickedimagefile);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          GFAvatar(
              radius: 120,
              backgroundImage: _pickedImage != null
                  ? FileImage(_pickedImage)
                  : widget.imageUrl == null || widget.imageUrl == ''
                      ? null
                      : NetworkImage(widget.imageUrl),
              shape: GFAvatarShape.standard),
          FlatButton.icon(
              textColor: Theme.of(context).primaryColor,
              onPressed: _pickImages,
              icon: Icon(Icons.image),
              label: Text('Add Image')),
        ],
      ),
    );
  }
}
