import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:myteam/api/api_rest.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:myteam/model/cart_items_model.dart';
import 'package:myteam/model/productsModel.dart';

class CartProvider extends ChangeNotifier {
  int _countCartItems = 0;
  List<CartItemsModel> _cartItems = [];
  bool updatingCart = false;
  bool loadingCart = false;
  get cartItems => _cartItems;
  get countCartItems => _countCartItems;

  resetCartItemsCount() {
    _countCartItems = 0;
    notifyListeners();
  }

  decreaseItemCount() {
    _countCartItems -= 1;
    notifyListeners();
  }

  IncreaseItemCount() {
    _countCartItems += 1;
    notifyListeners();
  }

  resetCartItemsList() {
    _cartItems.clear();
  }

  Future addToCart(AllProductsModel itemInfo) async {
    var response;
    var jsonData;
    var body = {
      'user': "1",
      'product': itemInfo.id.toString(),
      "qty": "1",
      "key": "56304086d65d2957e1acc01109937eef6cda5b7a",
    };

    try {
      response = await http.post(apiRest.addToCart(), body: body);
      jsonData = jsonDecode(response.body);
      jsonData['message'];
      if (response.statusCode == 200) {
        if (jsonData['message'] == 'Your product has been added to cart') {
          _countCartItems += 1;
          Fluttertoast.showToast(
              msg: "Added to cart", backgroundColor: Colors.green);
          notifyListeners();
        } else {
          Fluttertoast.showToast(
              msg: "Couldn't add to cart", backgroundColor: Colors.red);
          notifyListeners();
        }
      }
    } catch (ex) {
      Fluttertoast.showToast(
          msg: "Some error occured", backgroundColor: Colors.red);
      notifyListeners();
    }
  }

  Future getcartItemsCount() async {
    var response;
    var jsonData;
    var body = {
      'user': "1",
      "key": "56304086d65d2957e1acc01109937eef6cda5b7a",
    };
    try {
      response = await http.post(apiRest.getCart(), body: body);
      jsonData = jsonDecode(response.body);
      var data = jsonData['data'];

      if (response.statusCode == 200) {
        if (data != null && data != []) {
          for (var i = 0; i <= data.length - 1; i++) {
            _countCartItems = _countCartItems + data[i]['qty'];
            notifyListeners();
          }
        }
      } else {}
    } catch (ex) {
      print(ex);
    }
  }

  Future getcart() async {
    loadingCart = true;
    var response;
    var jsonData;
    var body = {
      'user': "1",
      "key": "56304086d65d2957e1acc01109937eef6cda5b7a",
    };
    try {
      response = await http.post(apiRest.getCart(), body: body);
      jsonData = jsonDecode(response.body);
      var data = jsonData['data'];

      if (response.statusCode == 200) {
        if (data != null && data != []) {
          for (var i = 0; i <= data.length - 1; i++) {
            _cartItems.add(CartItemsModel.fromJson(data[i]));
          }
        }
        if (_cartItems != null && _cartItems.isNotEmpty) {
          for (var i = 0; i <= _cartItems.length - 1; i++) {
            _countCartItems = _countCartItems + _cartItems[i].qty;
          }
        }
        loadingCart = false;
        notifyListeners();
      } else {
        loadingCart = false;
        notifyListeners();
        Fluttertoast.showToast(msg: 'Error Fetching Data');
      }
    } catch (ex) {
      loadingCart = false;
      notifyListeners();
      print(ex);
    }
  }

  Future removeFromCart(id) async {
    updatingCart = true;
    notifyListeners();
    bool _removedSuccessfully = false;
    var response;
    var jsonData;

    try {
      response = await http.post(apiRest.removeFromCart(id));
      jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        updatingCart = false;

        Fluttertoast.showToast(
            msg: 'Item removed Successfully', backgroundColor: Colors.green);
        _removedSuccessfully = true;
        notifyListeners();
      }
      List items;
    } catch (ex) {
      updatingCart = false;
      Fluttertoast.showToast(
          msg: 'Error removing item', backgroundColor: Colors.red);
      _removedSuccessfully = false;
      notifyListeners();
    }
    return _removedSuccessfully;
  }

  Future updateCart(id, data) async {
    updatingCart = true;
    notifyListeners();
    bool _updatedSuccessfully = false;
    var response;
    var jsonData;

    try {
      response = await http.post(apiRest.updateCart(id), body: data);
      jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        updatingCart = false;
        _updatedSuccessfully = true;

        notifyListeners();
      }
    } catch (ex) {
      Fluttertoast.showToast(
          msg: 'Error updating item quantity', backgroundColor: Colors.red);
      updatingCart = false;
      notifyListeners();
    }
    return _updatedSuccessfully;
  }
}
