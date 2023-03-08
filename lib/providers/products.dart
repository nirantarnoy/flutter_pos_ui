import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pos_ui/models/itemcart.dart';
import 'package:flutter_pos_ui/models/products.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class ProductData with ChangeNotifier {
  final String url_to_product_list =
      //   "http://192.168.60.196/goodpos/frontend/web/api/product/list";
      "http://192.168.60.195/goodpos/frontend/web/api/product/list";

  late List<Products> _product;
  List<Products> get listproduct => _product;
  late List<ItemCart> _itemcart;
  List<ItemCart> get listcart => _itemcart;
  List<ItemCart> orderItems = [];

  bool _isLoading = false;
  int _id = 0;
  double sumCartTotal = 0;

  int get idProductgroup => _id;

  set idProductgroup(int val) {
    _id = val;
    notifyListeners();
  }

  set listproduct(List<Products> val) {
    _product = val;
    notifyListeners();
  }

  set listcart(List<ItemCart> val) {
    _itemcart = val;
    notifyListeners();
  }

  bool get is_loading {
    return _isLoading;
  }

  void addCartItem(String id, String name, String qty, String price) {
    if (name != "") {
      ItemCart items = ItemCart(id: id, name: name, qty: qty, price: price);
      int index = -1;
      if (orderItems.isNotEmpty) {
        for (int i = 0; i <= orderItems.length - 1; i++) {
          if (orderItems[i].id == id) {
            index = i;
          }
        }
        if (index > -1) {
          orderItems[index].qty =
              (int.parse(orderItems[index].qty) + 1).toString();
        } else {
          orderItems.add(items);
        }
      } else {
        orderItems.add(items);
      }
      sumCartItem();
      notifyListeners();
    }
  }

  void removecartitem(int index) {
    orderItems.removeAt(index);
    sumCartItem();
    notifyListeners();
  }

  void clearcartitem() {
    orderItems.clear();
    sumCartItem();
    notifyListeners();
  }

  void sumCartItem() {
    sumCartTotal = 0;
    orderItems.forEach((items) {
      sumCartTotal += (double.parse(items.qty) * double.parse(items.price));
    });
  }

  Future<dynamic> fetchProductData(String productgroup) async {
    print('finding product data for ${productgroup}');
    final Map<String, dynamic> filterData = {'productgroup': productgroup};
    // _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_product_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<Products> data = [];
        print('data product length is ${res["data"].length}');
        //    print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          final Products productresult = Products(
            id: res['data'][i]['id'].toString(),
            name: res['data'][i]['name'].toString(),
            price: res['data'][i]['price'].toString(),
          );

          //  print('data from server is ${customerresult}');
          data.add(productresult);
        }

        listproduct = data;
        _isLoading = false;
        notifyListeners();
        return listproduct;
      }
    } catch (_) {
      print('something went wrong!');
    }
  }

  Future<List> findProductgroupx(String query) async {
    await Future.delayed(Duration(microseconds: 500));
    return listproduct
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }
}
