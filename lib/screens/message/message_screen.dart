import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/message/message.dart';
import '../../widgets/message/new_message.dart';

class MessageScreen extends StatelessWidget {
  static const routeName = '/new-message';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;

    final isrequest = routeArgs['isrequest'];
    final userto = routeArgs['userto'];
    var goodsid = '';
    if (isrequest == 'true') {
      goodsid = routeArgs['goodsid'];
    }

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
            future:
                Firestore.instance.collection('users').document(userto).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading....');
              }
              return Text(
                snapshot.data['username'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(
                userto: userto,
                isrequest: isrequest,
              ),
            ),
            NewMessage(
              userto: userto,
              isrequest: isrequest,
              goodsid: goodsid,
            ),
          ],
        ),
      ),
    );
  }
}
