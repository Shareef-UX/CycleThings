//import 'package:chatapp/Screens/SelectContact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_ui/custom_card.dart';
import '../../models/chat_recent.dart';

class MessageRecent extends StatefulWidget {
  @override
  _MessageRecentState createState() => _MessageRecentState();
}

class _MessageRecentState extends State<MessageRecent> {
  //List<ChatModel> chatmodels = [];

  Future<List<ChatRecent>> getAllData() async {
    final user = await FirebaseAuth.instance.currentUser();

    print("Active Users ${user.uid}");
    final val = await Firestore.instance
        .collection("message")
        .document(user.uid)
        .collection('chats')
        //.document('WZZq7XfZZZQJejODsJIwPUClt8f1')
        //.collection('chat')
        .getDocuments();

    //Getting all the documents

    //final List<DocumentSnapshot> documents = val.documents;
    var documents = val.documents;

    print("Documents ${documents.length}");

    /*val.documents.forEach((elm) {
      var docId = elm.documentID;
      var x = getChat(docId);
      print(docId);
    });*/

    //print("Documents ${documents.length}");
    if (documents.length > 0) {
      try {
        print("Active ${documents.length}");
        return documents.map((document) {
          ChatRecent chatmodels =
              ChatRecent.fromJson(Map<String, dynamic>.from(document.data));

          return chatmodels;
        }).toList();
      } catch (e) {
        print("Exception $e");
        return [];
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*floatingActionButton: FloatingActionButton(
        onPressed: () { 
          //Navigator.push(context,
          //  MaterialPageRoute(builder: (builder) => SelectContact()));
        },
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),*/
      body: FutureBuilder(
        future: getAllData(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: asyncSnapshot.data.length,
              itemBuilder: (contex, index) {
                //print(asyncSnapshot.data[index]);
                return CustomCard(
                  chatModel: asyncSnapshot.data[index],
                );
              });
        },
      ),
    );
  }
}
