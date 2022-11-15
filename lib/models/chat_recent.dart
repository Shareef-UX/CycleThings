class ChatRecent {
  String chatid;
  String content;
  String userId;
  String time;

  ChatRecent({
    this.chatid,
    this.content,
    this.userId,
    this.time,
  });

  ChatRecent.fromJson(Map<String, dynamic> json) {
    chatid = json['chatid'];
    content = json['content'];
    userId = json['userId'];
    time = json['timestamp'].toDate().toString().substring(10, 16);
  }

  /*factory ChatModel.fromSnapshot(DocumentSnapshot snapshot) {
    return ChatModel(
      id: snapshot.data['id'],
      name: snapshot.data['name'],
      icon: snapshot.data['icon'],
      currentMessage: snapshot.data['currentMessage'],
      time: snapshot.data['time'],
    );
  }*/

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatid'] = this.chatid;
    data['content'] = this.content;
    data['userId'] = this.userId;
    data['timestamp'] = this.time;

    return data;
  }
}

class TypeMessage {
  static const text = 'text';
  static const image = 'image';
  static const product = 'product';
}
