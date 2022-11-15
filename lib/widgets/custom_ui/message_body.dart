import 'package:app_donation/widgets/message/message_product.dart';
import 'package:flutter/material.dart';

import '../../models/chat_recent.dart';
import '../message/message_image.dart';
//import '../custom_ui/message_product.dart';

class MessageBody extends StatelessWidget {
  MessageBody(this.message, this.userId, this.type, this.isrequest, this.isMe,
      {this.key});

  final Key key;
  final String message;
  final String userId;
  final String type;
  final String isrequest;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.green[100] : Color(0xffE8E8E8),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          width: 220,
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 5,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
            children: <Widget>[
              /*FutureBuilder(
                  future: Firestore.instance
                      .collection('users')
                      .document(userId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading....');
                    }
                    return Text(
                      snapshot.data['username'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMe ? Colors.black : Colors.black,
                      ),
                    );
                  }),*/
              type == TypeMessage.product
                  ?
                  //product
                  MessageProduct(message)
                  : type == TypeMessage.image
                      ?
                      // image,
                      MessageImage(message)
                      : Text(
                          message,
                          style: TextStyle(
                            color: isMe ? Colors.black : Colors.black,
                          ),
                          textAlign: isMe ? TextAlign.left : TextAlign.right,
                        )
            ],
          ),
        ),
      ],
    );
  }
}
