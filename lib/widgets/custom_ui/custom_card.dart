import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/chat_recent.dart';
import '../../screens/message/message_screen.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key key,
    this.chatModel,
  }) : super(key: key);

  final ChatRecent chatModel;

  @override
  Widget build(BuildContext context) {
    final len = 35;

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          MessageScreen.routeName,
          arguments: {
            'userto': chatModel.userId,
            'isrequest': 'false',
          },
        );
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: SvgPicture.asset(
                "assets/person.svg",
                color: Colors.white,
                height: 36,
                width: 36,
              ),
              backgroundColor: Colors.blueGrey,
            ),
            title: FutureBuilder(
                future: Firestore.instance
                    .collection('users')
                    .document(chatModel.userId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading....');
                  }
                  return Text(
                    snapshot.data['username'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
            subtitle: Row(
              children: [
                /*Icon(
                  Icons.done_all_outlined,
                ),
                SizedBox(
                  width: 3,
                ),*/
                Text(
                  chatModel.content.length > len
                      ? chatModel.content.substring(0, len) + '...'
                      : chatModel.content,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            trailing: Text(chatModel.time),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
