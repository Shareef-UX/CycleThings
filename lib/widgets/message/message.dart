import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../custom_ui/message_body.dart';

class Messages extends StatelessWidget {
  final String userto;
  final String isrequest;
  final String goodsid;

  Messages({
    @required this.userto,
    @required this.isrequest,
    this.goodsid,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
              stream: Firestore.instance
                  .collection('message')
                  .document(futureSnapshot.data.uid)
                  .collection('chats')
                  .document(userto)
                  .collection('chat')
                  .orderBy(
                    'timestamp',
                    descending: true,
                  )
                  .snapshots(),
              builder: (ctx, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final chatDocs = chatSnapshot.data.documents;
                return ListView.builder(
                    reverse: true,
                    itemCount: chatDocs.length,
                    itemBuilder: (ctx, index) {
                      return MessageBody(
                        chatDocs[index]['content'],
                        chatDocs[index]['userId'],
                        chatDocs[index]['type'],
                        isrequest,
                        chatDocs[index]['userId'] == futureSnapshot.data.uid,
                        key: ValueKey(chatDocs[index].documentID),
                      );
                    });
              });
        });
  }
}
