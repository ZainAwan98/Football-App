class AllProductsModel {
  int id;
  String title;
  String sku;
  int stock;
  String stockStatus;
  int regularPrice;
  int salePrice;
  String category;
  String description;
  String image;
  String date;

  AllProductsModel(
      {this.id,
      this.title,
      this.sku,
      this.stock,
      this.stockStatus,
      this.regularPrice,
      this.salePrice,
      this.category,
      this.description,
      this.image,
      this.date});

  AllProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    sku = json['sku'];
    stock = json['stock'];
    stockStatus = json['stockStatus'];
    regularPrice = json['regularPrice'];
    salePrice = json['salePrice'];
    category = json['category'];
    description = json['description'];
    image = json['image'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['sku'] = this.sku;
    data['stock'] = this.stock;
    data['stockStatus'] = this.stockStatus;
    data['regularPrice'] = this.regularPrice;
    data['salePrice'] = this.salePrice;
    data['category'] = this.category;
    data['description'] = this.description;
    data['image'] = this.image;
    data['date'] = this.date;
    return data;
  }
}
