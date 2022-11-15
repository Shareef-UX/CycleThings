import 'package:app_donation/models/chat_recent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  final String userto;
  final String isrequest;
  final String goodsid;

  NewMessage({@required this.userto, this.isrequest, this.goodsid});

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  bool show = false;
  final _controller = new TextEditingController();

  @override
  void initState() {
    // Provider.of<>(context)
    final _request = widget.isrequest;

    if (_request == 'true') {
      _sendMessage(
        widget.goodsid,
        TypeMessage.product,
      );
      print('didChangeDependencies(), counter = $_request');
    }
    //print('didChangeDependencies(), counter = $_request');
    super.initState();
  }

  void _sendMessage(String enterMessage, String typeMessage) async {
    String docsChat = DateTime.now().millisecondsSinceEpoch.toString();

    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();

    _insertSender(
      enterMessage,
      typeMessage,
      user.uid,
      widget.userto,
      docsChat,
    );
    _insertReciper(
      enterMessage,
      typeMessage,
      user.uid,
      widget.userto,
      docsChat,
    );

    _controller.clear();
  }

  void _insertSender(
    String content,
    String typeMessage,
    String userIdForm,
    String userIdTo,
    String docsChat,
  ) async {
    // Sender data
    await Firestore.instance
        .collection('message')
        .document(userIdForm)
        .collection('chats')
        .document(userIdTo)
        .collection('chat')
        .document(docsChat)
        .setData({
      'chatid': docsChat,
      'timestamp': Timestamp.now(),
      'content': content,
      'type': typeMessage,
      'status': 'sender',
      'userId': userIdForm,
    });

    final countRecentData = await Firestore.instance
        .collection("message")
        .document(userIdForm)
        .collection('chats')
        .where('userId', isEqualTo: userIdTo)
        .getDocuments();

    final needUpdate = countRecentData.documents.length > 0 ? true : false;

    if (needUpdate) {
      // recent Sender
      Firestore.instance
          .collection('message')
          .document(userIdForm)
          .collection('chats')
          .document(userIdTo)
          .updateData({
        'chatid': docsChat,
        'timestamp': Timestamp.now(),
        'content': content,
        'userId': userIdTo,
      });
    } else {
      Firestore.instance
          .collection('message')
          .document(userIdForm)
          .collection('chats')
          .document(userIdTo)
          .setData({
        'chatid': docsChat,
        'timestamp': Timestamp.now(),
        'content': content,
        'userId': userIdTo,
      });
    }
  }

  void _insertReciper(
    String content,
    String typeMessage,
    String userIdForm,
    String userIdTo,
    String docsChat,
  ) async {
    // Recipient data
    await Firestore.instance
        .collection('message')
        .document(userIdTo)
        .collection('chats')
        .document(userIdForm)
        .collection('chat')
        .document(docsChat)
        .setData({
      'chatid': docsChat,
      'timestamp': Timestamp.now(),
      'content': content,
      'type': typeMessage,
      'status': 'recipier',
      'userId': userIdForm,
    });

    final countRecentData = await Firestore.instance
        .collection("message")
        .document(userIdTo)
        .collection('chats')
        .where('userId', isEqualTo: userIdForm)
        .getDocuments();

    final needUpdate = countRecentData.documents.length > 0 ? true : false;
    //print('Reciper=>${needUpdate}');
    if (needUpdate) {
      //recent Recipier data
      Firestore.instance
          .collection('message')
          .document(userIdTo)
          .collection('chats')
          .document(userIdForm)
          .updateData({
        'chatid': docsChat,
        'timestamp': Timestamp.now(),
        'content': content,
        'userId': userIdForm,
      });
    } else {
      //recent Recipier data
      Firestore.instance
          .collection('message')
          .document(userIdTo)
          .collection('chats')
          .document(userIdForm)
          .setData({
        'chatid': docsChat,
        'timestamp': Timestamp.now(),
        'content': content,
        'userId': userIdForm,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 70,
                    child: Card(
                      margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        controller: _controller,
                        focusNode: focusNode,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        onChanged: (value) {
                          if (value.length > 0) {
                            setState(() {
                              sendButton = true;
                            });
                          } else {
                            setState(() {
                              sendButton = false;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: IconButton(
                            icon: Icon(
                              Icons.keyboard,
                            ),
                            onPressed: () {
                              if (!show) {
                                focusNode.unfocus();
                                focusNode.canRequestFocus = false;
                              }
                              setState(() {
                                show = !show;
                              });
                            },
                          ),
                          /*suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /*IconButton(
                                icon: Icon(Icons.attach_file),
                                onPressed: () {
                                  showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (builder) => bottomSheet());
                                },
                              ),*/
                              IconButton(
                                icon: Icon(Icons.camera_alt),
                                onPressed: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (builder) =>
                                  //             CameraApp()));
                                },
                              ),
                            ],
                          ),*/
                          contentPadding: EdgeInsets.all(5),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                      right: 2,
                      left: 2,
                    ),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        icon: Icon(
                          //sendButton ? Icons.send : Icons.mic,
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (sendButton) {
                            /*_scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );*/
                            _sendMessage(
                              _controller.text,
                              TypeMessage.text,
                              //widget.sourchat.id,
                              //widget.chatModel.id
                            );
                            _controller.clear();
                            setState(() {
                              sendButton = false;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              //show ? emojiSelect() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  /*Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }*/
}
