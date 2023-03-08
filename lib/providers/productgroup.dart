import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pos_ui/models/product_group_menu.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class ProductgroupData with ChangeNotifier {
  final String url_to_productgroup_list =
      //   "http://192.168.60.196/goodpos/frontend/web/api/productgroup/list";
      "http://192.168.60.195/goodpos/frontend/web/api/productgroup/list";

  late List<ProductGroupMenu> _productgroup;
  List<ProductGroupMenu> get listproductgroup => _productgroup;
  bool _isLoading = false;
  int _id = 0;

  int get idProductgroup => _id;

  set idProductgroup(int val) {
    _id = val;
    notifyListeners();
  }

  set listproductgroup(List<ProductGroupMenu> val) {
    _productgroup = val;
    notifyListeners();
  }

  bool get is_loading {
    return _isLoading;
  }

  Future<dynamic> fetchProductgroup() async {
    String? _current_route_id = "";
    String? _company_id = "";
    String? _branch_id = "";
    String? _car_id = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getString('user_id') != null) {
    //   _current_route_id = prefs.getString('emp_route_id');
    //   _company_id = prefs.getString('company_id');
    //   _branch_id = prefs.getString('branch_id');
    //   _car_id = prefs.getString('emp_car_id');
    // }

    final Map<String, dynamic> filterData = {
      'group': '',
    };
    // _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_productgroup_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<ProductGroupMenu> data = [];
        print('data productgroup length is ${res["data"].length}');
        //    print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          final ProductGroupMenu groupresult = ProductGroupMenu(
            id: res['data'][i]['id'].toString(),
            name: res['data'][i]['name'].toString(),
            isactive: i == 0 ? true : false,
          );

          //  print('data from server is ${customerresult}');
          data.add(groupresult);
        }

        listproductgroup = data;
        _isLoading = false;
        notifyListeners();
        return listproductgroup;
      }
    } catch (_) {}
  }

  Future<List> findProductgroup(String query) async {
    await Future.delayed(Duration(microseconds: 500));
    return listproductgroup
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }
}
