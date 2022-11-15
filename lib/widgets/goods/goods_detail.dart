import 'package:app_donation/widgets/custom_ui/load_image.dart';
import 'package:flutter/material.dart';

import 'goods_desc.dart';

class GoodsDetail extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String condition;
  final String location;
  final String imageUrl;
  final String userId;
  final Function toggleFavorite;
  final Function isFavorite;

  GoodsDetail(
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

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: LoadImage(imageUrl, 350, 400),
              ),
              Align(
                alignment: Alignment.bottomRight,
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
                    padding: EdgeInsets.all(10),
                    primary: Colors.purple, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(2),
            child: GoodsDesc(
              title: title,
              description: description,
              condition: condition,
              location: location,
            ),
          ),
        ],
      ),
    );
  }
}
