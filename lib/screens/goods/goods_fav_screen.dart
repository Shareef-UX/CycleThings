import 'package:app_donation/widgets/goods/goods_listed.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/goods/goods_item_fav.dart';

class GoodsFavScreen extends StatefulWidget {
  @override
  _GoodsFavScreenState createState() => _GoodsFavScreenState();
}

class _GoodsFavScreenState extends State<GoodsFavScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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
      //print('Insert Favorite');
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

      //print('Delete Favorite');
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // give the tab bar a height [can change hheight to preferred height]
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.purple[300],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: Colors.purple,
                ),
                labelColor: Colors.amber,
                unselectedLabelColor: Colors.white,
                tabs: [
                  // first tab [you can add an icon using the icon property]
                  Tab(
                    text: 'Favorited',
                  ),

                  // second tab [you can add an icon using the icon property]
                  Tab(
                    text: 'Listed',
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  // first tab bar view widget
                  FutureBuilder(
                    future: FirebaseAuth.instance.currentUser(),
                    builder: (ctx, futureSnapshot) {
                      if (futureSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return StreamBuilder(
                        stream: Firestore.instance
                            .collection('fav_goods')
                            .document(futureSnapshot.data.uid)
                            .collection('goods')
                            .snapshots(),
                        builder: (ctx, goodsSnapshot) {
                          if (goodsSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final goodsDocs = goodsSnapshot.data.documents;
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: goodsDocs.length,
                            itemBuilder: (ctx, index) {
                              return GoodsItemFavorite(
                                _toggleFavorite,
                                _isGoodsFavorite,
                                goodsDocs[index]['id'],
                                goodsDocs[index]['title'],
                                goodsDocs[index]['description'],
                                goodsDocs[index]['condition'],
                                goodsDocs[index]['location'],
                                goodsDocs[index]['image'],
                                goodsDocs[index]['userId'],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),

                  // second tab bar view widget
                  FutureBuilder(
                    future: FirebaseAuth.instance.currentUser(),
                    builder: (ctx, futureSnapshot) {
                      if (futureSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return StreamBuilder(
                        stream:
                            Firestore.instance.collection('goods').snapshots(),
                        builder: (ctx, goodsSnapshot) {
                          if (goodsSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final goodsDocs = goodsSnapshot.data.documents;
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: goodsDocs.length,
                            itemBuilder: (ctx, index) {
                              return GoodsListed(
                                goodsDocs[index].documentID,
                                goodsDocs[index]['title'],
                                goodsDocs[index]['description'],
                                goodsDocs[index]['condition'],
                                goodsDocs[index]['location'],
                                goodsDocs[index]['category'],
                                goodsDocs[index]['images'],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
