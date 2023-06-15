class CartItemsModel {
  int itemId;
  String image;
  String title;
  int price;
  int qty;
  int subTotal;

  CartItemsModel(
      {this.itemId,
      this.image,
      this.title,
      this.price,
      this.qty,
      this.subTotal});

  CartItemsModel.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    image = json['image'];
    title = json['title'];
    price = json['price'];
    qty = json['qty'];
    subTotal = json['subTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['image'] = this.image;
    data['title'] = this.title;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['subTotal'] = this.subTotal;
    return data;
  }
}
