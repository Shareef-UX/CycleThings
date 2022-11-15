import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/goods/goods_detail.dart';
import '../../screens/message/message_screen.dart';

class GoodsDetailScreen extends StatefulWidget {
  static const routeName = '/goods-detail';

  @override
  _GoodsDetailScreenState createState() => _GoodsDetailScreenState();
}

class _GoodsDetailScreenState extends State<GoodsDetailScreen> {
  void _toggleFavorite(
    String goodsid,
    String title,
    String description,
    String condition,
    String location,
    String imageUrl,
    String userId,
    BuildContext ctx,
  ) async {
    final user = await FirebaseAuth.instance.currentUser();
    //final String favid = user.uid + goodsid;

    //print('favoriteid${favid}');

    /*final queryFav = await Firestore.instance
        .collection('fav_goods')
        .where("favid", isEqualTo: favid)
        .getDocuments();*/

    final queryFav = await Firestore.instance
        .collection('fav_goods')
        .document(user.uid)
        .collection('goods')
        .where("goodsid", isEqualTo: goodsid)
        .getDocuments();

    //print('getdata=>${queryFav.documents.length}');

    if (queryFav.documents.length == 0) {
      /*Firestore.instance.collection('fav_goods').add({
        'favid': favid,
        'goodsid': goodsid,
        'userId': user.uid,
        'createdAt': Timestamp.now(),
      });*/

      //print(userId);

      Firestore.instance
          .collection('fav_goods')
          .document(user.uid)
          .collection('goods')
          .document(goodsid)
          .setData({
        'goodsid': goodsid,
        'title': title,
        'condition': condition,
        'description': description,
        'location': location,
        'image': imageUrl,
        'isFavorite': true,
        'userId': userId,
        'createdAt': Timestamp.now(),
      });

      setState(() {});
    } else {
      setState(() {});
      //String docId = '';

      /*Firestore.instance
          .collection('fav_goods')
          .where("favid", isEqualTo: favid)
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          print(element.documentID);
        });
      });*/

      /*queryFav.documents.forEach((elm) {
        docId = elm.documentID;
      });*/

      //print('documentId=>${docId}');
      await Firestore.instance
          .collection('fav_goods')
          .document(user.uid)
          .collection('goods')
          .document(goodsid)
          .delete();
    }
  }

  Future<bool> _isGoodsFavorite(
    String goodsid,
  ) async {
    bool rest = false;
    final user = await FirebaseAuth.instance.currentUser();

    /*final queryFav = await Firestore.instance
        .collection('fav_goods')
        .where("favid", isEqualTo: favid)
        .getDocuments();*/

    final queryFav = await Firestore.instance
        .collection('fav_goods')
        .document(user.uid)
        .collection('goods')
        .where("goodsid", isEqualTo: goodsid)
        .getDocuments();

    //print('getdata=>${queryFav.documents.length}');
    rest = queryFav.documents.length > 0 ? true : false;

    return rest;
  }

  void selectedItem(
    BuildContext ctx,
    String goodsid,
    String title,
    String idto,
  ) {
    Navigator.of(ctx).pushNamed(
      MessageScreen.routeName,
      arguments: {
        'goodsid': goodsid,
        'userto': idto,
        'isrequest': 'true',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;

    final id = routeArgs['id'];
    final title = routeArgs['title'];
    final description = routeArgs['description'];
    final condition = routeArgs['condition'];
    final location = routeArgs['location'];
    final imageUrl = routeArgs['imageUrl'];
    final userId = routeArgs['userId'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GoodsDetail(
              _toggleFavorite,
              _isGoodsFavorite,
              id,
              title,
              description,
              condition,
              location,
              imageUrl,
              userId,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "Request Item",
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        onPressed: () => selectedItem(
          context,
          id,
          title,
          userId,
        ),
      ),
    );
  }
}
