class Goods {
  String goodsid;
  String category;
  String title;
  String imageUrl;
  String description;
  String condition;
  String location;
  String userId;

  Goods({
    this.goodsid,
    this.category,
    this.title,
    this.imageUrl,
    this.description,
    this.condition,
    this.location,
    this.userId,
  });

  Goods.fromJson(Map<String, dynamic> json) {
    goodsid = json['goodsid'];
    category = json['category'];
    title = json['title'];
    imageUrl = json['imageUrl'];
    description = json['description'];
    condition = json['condition'];
    location = json['location'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goodsid'] = this.goodsid;
    data['category'] = this.category;
    data['title'] = this.title;
    data['imageUrl'] = this.imageUrl;
    data['description'] = this.description;
    data['condition'] = this.condition;
    data['location'] = this.location;
    data['userId'] = this.userId;

    return data;
  }
}
