import 'package:app_donation/widgets/custom_ui/load_image.dart';
import 'package:flutter/material.dart';

import '../../screens/goods/goods_detail_screen.dart';

class GoodsItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String condition;
  final String location;
  final String imageUrl;
  final String userId;
  final Function toggleFavorite;
  final Function isFavorite;

  GoodsItem(
    this.toggleFavorite,
    this.isFavorite,
    this.id,
    this.title,
    this.description,
    this.condition,
    this.location,
    this.imageUrl,
    this.userId,
  );

  void selectItem(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      GoodsDetailScreen.routeName,
      arguments: {
        'id': id,
        'title': title,
        'description': description,
        'condition': condition,
        'location': location,
        'imageUrl': imageUrl,
        'userId': userId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final len = 15;

    return InkWell(
      onTap: () => selectItem(context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        margin: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: LoadImage(imageUrl, 200, 200),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: () => toggleFavorite(
                      id,
                      title,
                      description,
                      condition,
                      location,
                      imageUrl,
                      userId,
                      context,
                    ),
                    child: FutureBuilder(
                      future: isFavorite(id),
                      builder: (context, AsyncSnapshot<bool> snapshot) {
                        //print(snapshot.data);
                        if (snapshot.data == true) {
                          return Icon(
                            Icons.favorite,
                            color: Colors.red,
                          );
                        } else {
                          return Icon(
                            Icons.favorite,
                            color: Colors.white,
                          );
                        }
                      },
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(1),
                      primary: Colors.purple, // <-- Button color
                      onPrimary: Colors.red, // <-- Splash color
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      title.length > len
                          ? title.substring(0, len) + '...'
                          : title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
