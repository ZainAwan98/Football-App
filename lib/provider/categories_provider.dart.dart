import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:myteam/api/api_rest.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myteam/model/categoriesModel.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:myteam/api/api_config.dart';

class ShopCategoriesProvider extends ChangeNotifier {
  bool isLoading = false;
  List<CategoriesData> _categoriesData = [];

  get categoriesData => _categoriesData;

  Future<List<CategoriesData>> getCategories(context) async {
    isLoading = true;
    var responce = await getShopCategory(context).then((value) {
      _categoriesData = value;
      isLoading = false;
    });

    notifyListeners();
    return _categoriesData;
  }

  Future getShopCategory(context) async {
    List<CategoriesData> categories = [
      CategoriesData(id: 0, name: 'All'),
    ];
    CategoriesData _data;
    try {
      final response = await http.get(
        apiRest.getCategories(),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      print(response);
      var decoded = json.decode(response.body);
      List data = decoded['data'];

      // result = response['data'];
      if (response.statusCode == 200) {
        for (var i = 0; i <= data.length - 1; i++) {
          categories.add(CategoriesData(
            id: data[i]['id'],
            name: data[i]['name'],
          ));
        }
        // categories = CategoriesModel(data: data);
        // result = PostModel.fromJson(item);
      } else {
        print('data not found');
      }
    } catch (e) {
      log(e);
    }
    return categories;
  }
}
