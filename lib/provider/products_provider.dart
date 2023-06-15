import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:myteam/api/api_rest.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myteam/model/categoriesModel.dart';
import 'package:myteam/model/productsModel.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:myteam/api/api_config.dart';

class ProductsProvider extends ChangeNotifier {
  int _page = 0;

  get page => _page;
  bool isFirstLoading = false;
  bool isLoading = false;
  List<AllProductsModel> _allProductsData = [];
  List<AllProductsModel> _productById = [];

  resetAllProducts() {
    _allProductsData = [];
    notifyListeners();
  }

  get allProductsData => _allProductsData;
  get productById => _productById;
  setPageCountToZero() {
    _page = 0;
    notifyListeners();
  }

  Future<List<AllProductsModel>> getProducts(
      context, page, bool isloadingMore) async {
    if (isloadingMore == false) {
      isFirstLoading = true;
      notifyListeners();
    }
    if (isloadingMore == true) {
      isLoading = true;
      notifyListeners();
    }

    _page += 1;
    page = _page;

    var responce =
        await getAllProducts(context, page, isloadingMore).then((value) {
      for (var i = 0; i <= value.length - 1; i++) {
        _allProductsData.add(value[i]);
      }

      isLoading = false;
      isFirstLoading = false;
    });

    notifyListeners();
    return _allProductsData;
  }

  Future<List<AllProductsModel>> productsById(
      context, id, bool isloadingMore) async {
    resetAllProducts();
    if (isloadingMore == false) {
      isFirstLoading = true;
      notifyListeners();
    }
    if (isloadingMore == true) {
      isLoading = true;
      notifyListeners();
    }

    // _page += 1;
    // page = _page;

    var responce = await getProductById(context, id).then((value) {
      for (var i = 0; i <= value.length - 1; i++) {
        _allProductsData.add(value[i]);
      }

      isLoading = false;
      isFirstLoading = false;
    });

    notifyListeners();
    return _allProductsData;
  }

  Future<List<AllProductsModel>> getAllProducts(
      context, page, bool isLoadingMore) async {
    if (isLoadingMore) {
    } else {
      resetAllProducts();
    }

    List<AllProductsModel> allProductsData = [];

    try {
      final response = await http.get(
        apiRest.getAllProducts(page),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      log('${response.body}');
      var decoded = json.decode(response.body);
      decoded['message'];
      List data = decoded['data'];

      // result = response['data'];
      if (response.statusCode == 200) {
        if (decoded['success'] == false &&
            decoded['message'] == 'No products found') {
          _page--;
          Fluttertoast.showToast(msg: 'No more products');
        } else {
          resetAllProducts();
          for (var i = 0; i <= data.length - 1; i++) {
            allProductsData.add(AllProductsModel.fromJson(data[i]));
          }
        }

        // }

        // categories = CategoriesModel(data: data);
        // result = PostModel.fromJson(item);
      } else {
        Fluttertoast.showToast(msg: 'Error Fetching Data');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error Fetching Data');
    }

    return allProductsData;
  }

  Future<List<AllProductsModel>> getProductById(context, id) async {
    List<AllProductsModel> productsById = [];

    try {
      final response = await http.get(
        apiRest.getProductById(id),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      log('${response.body}');
      var decoded = json.decode(response.body);
      decoded['message'];
      Map data = decoded['data'];

      // result = response['data'];
      if (response.statusCode == 200) {
        if (decoded['success'] == false &&
            decoded['message'] == 'No products found') {
          Fluttertoast.showToast(msg: 'No more products');
        } else {
          productsById.add(AllProductsModel.fromJson(data));
        }

        // }

        // categories = CategoriesModel(data: data);
        // result = PostModel.fromJson(item);
      } else {
        Fluttertoast.showToast(msg: 'Error Fetching Data');
      }
    } catch (e) {
      log(e);
    }
    return productsById;
  }
}
