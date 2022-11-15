import 'package:app_donation/screens/goods/goods_detail_screen.dart';
import 'package:app_donation/screens/goods/goods_input_screen.dart';
import 'package:app_donation/widgets/custom_ui/load_image.dart';
import 'package:flutter/material.dart';

class GoodsListed extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String condition;
  final String location;
  final String category;
  final String imageUrl;

  GoodsListed(
    this.id,
    this.title,
    this.description,
    this.condition,
    this.location,
    this.category,
    this.imageUrl,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  child: LoadImage(imageUrl, 250, 400),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return GoodsInputScreen(
                            goodsid: id,
                            category: category,
                            condition: condition,
                            description: description,
                            location: location,
                            title: title,
                            imageUrl: imageUrl,
                            isedit: true,
                          );
                        },
                      ),
                    ),
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
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
                      title,
                      style: TextStyle(
                        fontSize: 20,
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
