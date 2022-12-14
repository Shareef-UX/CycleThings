import 'dart:io';

import 'package:app_donation/widgets/picker/goods_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GoodsForm extends StatefulWidget {
  //static const routeName = '/goods-form';

  final String goodsid;
  final String title;
  final String category;
  final String description;
  final String condition;
  final String location;
  final String imageUrl;
  final bool isedit;

  GoodsForm({
    this.goodsid,
    this.title,
    this.category,
    this.description,
    this.condition,
    this.location,
    this.imageUrl,
    @required this.isedit,
  });

  @override
  _GoodsFormState createState() => _GoodsFormState();
}

class _GoodsFormState extends State<GoodsForm> {
  final _formKey = GlobalKey<FormState>();
  var goodsid;
  var imageController = TextEditingController();
  var titleController = TextEditingController();
  var categoryController = TextEditingController();
  var descController = TextEditingController();
  var conditionController = TextEditingController();
  var locationController = TextEditingController();
  var _isedit = true;
  String selectedValue = "c1";
  File _goodImageFile;

  @override
  void initState() {
    super.initState();
    // print(widget.isedit);
    //print(widget.imageUrl);
    _isedit = widget.isedit;
    goodsid = widget.goodsid;
    titleController.text = widget.title;
    descController.text = widget.description;
    conditionController.text = widget.condition;
    locationController.text = widget.location;
    selectedValue = widget.category;
  }

  void _pickedImage(File image) {
    _goodImageFile = image;
  }

  void _trySubmit(
    String _title,
    String _category,
    String _description,
    String _condition,
    String _location,
    String _imageurl,
    File image,
    BuildContext ctx,
  ) async {
    final user = await FirebaseAuth.instance.currentUser();
    final isValid = _formKey.currentState.validate();
    String docsChat = DateTime.now().millisecondsSinceEpoch.toString();
    FocusScope.of(context).unfocus();
    if (_goodImageFile == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    //print(isValid);
    if (isValid) {
      final refUpload = FirebaseStorage.instance
          .ref()
          .child('goods_images')
          .child(docsChat + '.jpg');
      await refUpload.putFile(image).onComplete;
      var urlimage = await refUpload.getDownloadURL();
      //print(_category);
      // _formKey.currentState.save();
      Firestore.instance.collection('goods').add({
        'id': docsChat,
        'category': _category,
        'title': _title,
        'description': _description,
        'condition': _condition,
        'location': _location,
        'images': urlimage,
        'userId': user.uid,
      });

      Navigator.of(context).pop();
    }
  }

  void _tryUpdate(
    String _title,
    String _category,
    String _description,
    String _condition,
    String _location,
    String _imageurl,
    File image,
    BuildContext ctx,
  ) async {
    final user = await FirebaseAuth.instance.currentUser();
    final isValid = _formKey.currentState.validate();
    //String docsChat = DateTime.now().millisecondsSinceEpoch.toString();

    FocusScope.of(context).unfocus();
    //print(goodsid);
    // }
    var urlimage;
    if (_goodImageFile != null) {
      final refUpload = FirebaseStorage.instance
          .ref()
          .child('goods_images')
          .child(goodsid + '.jpg');
      await refUpload.putFile(image).onComplete;
      urlimage = await refUpload.getDownloadURL();
    } else {
      urlimage = widget.imageUrl;
    }
    ;
    if (isValid) {
      // _formKey.currentState.save();
      Firestore.instance.collection('goods').document(goodsid).updateData({
        'category': _category,
        'title': _title,
        'description': _description,
        'condition': _condition,
        'location': _location,
        'images': urlimage,
        'userId': user.uid,
      });
      Navigator.of(context).pop();
    }
  }

  void _tryDelete(
    String _id,
    BuildContext ctx,
  ) async {
    FocusScope.of(context).unfocus();
    Firestore.instance.collection('goods').document(goodsid).delete();

    Navigator.of(context).pop();
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Clothes"), value: "c1"),
      DropdownMenuItem(child: Text("Books"), value: "c2"),
      DropdownMenuItem(child: Text("Electronics"), value: "c3"),
      DropdownMenuItem(child: Text("Furniture"), value: "c4"),
      DropdownMenuItem(child: Text("Appliances"), value: "c5"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GoodsImagePicker(_pickedImage, widget.imageUrl),
                SizedBox(height: 10),
                Text(
                  'Name of Item',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                      hintText: "Name of Item",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Colors.white,
                      filled: true),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Name is Required!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) =>
                      value == null ? "Select a category" : null,
                  dropdownColor: Colors.white,
                  value: selectedValue,
                  onChanged: (String newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  },
                  items: dropdownItems,
                ),
                SizedBox(height: 10),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: descController,
                  decoration: InputDecoration(
                      hintText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Colors.white,
                      filled: true),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Description is Required!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Condition',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: conditionController,
                  decoration: InputDecoration(
                      hintText: "Condition",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Colors.white,
                      filled: true),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Condition is Required!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(
                      hintText: "Location",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Colors.white,
                      filled: true),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Location is Required!';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                //if (widget.isLoading) CircularProgressIndicator(),
                //if (!widget.isLoading)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_isedit)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: RaisedButton(
                          child: Text('Add List Item'),
                          onPressed: () => _trySubmit(
                              titleController.text,
                              selectedValue,
                              descController.text,
                              conditionController.text,
                              locationController.text,
                              imageController.text,
                              _goodImageFile,
                              context),
                        ),
                      ),
                    if (_isedit)
                      Align(
                        child: RaisedButton(
                          child: Text('Update Item'),
                          onPressed: () => _tryUpdate(
                              titleController.text,
                              selectedValue,
                              descController.text,
                              conditionController.text,
                              locationController.text,
                              imageController.text,
                              _goodImageFile,
                              context),
                        ),
                      ),
                    if (_isedit)
                      Align(
                        child: RaisedButton(
                          child: Text('Delete Item'),
                          onPressed: () => _tryDelete(goodsid, context),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
