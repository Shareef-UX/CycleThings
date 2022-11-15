import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_ui/load_image.dart';

class MessageProduct extends StatelessWidget {
  MessageProduct(this.content);

  final String content;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firestore.instance.collection('goods').document(content).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading....');
          }
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            margin: EdgeInsets.all(1),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: LoadImage(
                        snapshot.data['images'],
                        200,
                        200,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(2),
                  child: Text(snapshot.data['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ),
              ],
            ),
          );
        });
  }
}
