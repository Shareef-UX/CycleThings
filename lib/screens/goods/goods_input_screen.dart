import 'package:app_donation/widgets/goods/goods_form.dart';
import 'package:flutter/material.dart';

class GoodsInputScreen extends StatefulWidget {
  final String goodsid;
  final String title;
  final String category;
  final String description;
  final String condition;
  final String location;
  final String imageUrl;
  final bool isedit;

  GoodsInputScreen({
    this.goodsid,
    this.title,
    this.category,
    this.description,
    this.condition,
    this.location,
    this.imageUrl,
    this.isedit,
  });
  @override
  _GoodsInputScreenState createState() => _GoodsInputScreenState();
}

class _GoodsInputScreenState extends State<GoodsInputScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _selectedPageIndex = widget.isedit ? 1 : 0;

    _pages = [
      {
        'title': 'Register Item',
      },
      {
        'title': 'Change Details',
      }
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
      ),
      body: GoodsForm(
        goodsid: widget.goodsid,
        title: widget.title,
        category: widget.category,
        description: widget.description,
        condition: widget.condition,
        location: widget.location,
        imageUrl: widget.imageUrl,
        isedit: widget.isedit,
      ),
    );
  }
}
