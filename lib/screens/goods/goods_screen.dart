import 'dart:math';
import 'package:app_donation/screens/goods/goods_input_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../widgets/goods/goods_item.dart';

class GoodsScreen extends StatefulWidget {
  @override
  _GoodsScreenState createState() => _GoodsScreenState();
}

class _GoodsScreenState extends State<GoodsScreen> {
  List<StaggeredTile> generateRandomTiles(int count) {
    Random rnd = new Random();
    List<StaggeredTile> _staggeredTiles = [];
    for (int i = 0; i < count; i++) {
      num mainAxisCellCount = 0;
      double max = 0.6;
      //double temp = rnd.nextDouble() * max;
      double temp = max;

      if (temp > 0.6) {
        mainAxisCellCount = temp + 0.5;
      } else if (temp < 0.3) {
        mainAxisCellCount = temp + 0.9;
      } else {
        mainAxisCellCount = temp + 0.7;
      }

      //mainAxisCellCount min 1.2
      _staggeredTiles
          .add(new StaggeredTile.count(rnd.nextInt(1) + 1, mainAxisCellCount));
    }
    return _staggeredTiles;
  }

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

    final queryFav = await Firestore.instance
        .collection('fav_goods')
        .document(user.uid)
        .collection('goods')
        .where("goodsid", isEqualTo: goodsid)
        .getDocuments();

    if (queryFav.documents.length == 0) {
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

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> getGoodsStream(String currentUser, int limit) {
      //print(currentUser);
      return Firestore.instance
          .collection('goods')
          //.orderBy(FirestoreConstants.timestamp, descending: true)
          /*.where(
            "userId",
            isLessThan: currentUser,
          )*/
          .limit(limit)
          .snapshots();
    }

    return Scaffold(
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: getGoodsStream(futureSnapshot.data.uid, 10),
            builder: (ctx, goodsSnapShot) {
              if (goodsSnapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final goodsDocs = goodsSnapShot.data.documents;
              return StaggeredGridView.count(
                crossAxisCount: 2,
                physics: new BouncingScrollPhysics(),
                children: goodsDocs
                    .map<Widget>((catData) => GoodsItem(
                          _toggleFavorite,
                          _isGoodsFavorite,
                          catData.documentID,
                          catData['title'],
                          catData['description'],
                          catData['condition'],
                          catData['location'],
                          catData['images'],
                          catData['userId'],
                        ))
                    .toList(),
                staggeredTiles: generateRandomTiles(goodsDocs.length),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return GoodsInputScreen(
                isedit: false,
              );
            },
          ),
        ),
      ),
    );
  }
}
