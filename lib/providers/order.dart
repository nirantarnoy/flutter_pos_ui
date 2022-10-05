import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_pos_ui/models/itemcart.dart';
import 'package:flutter_pos_ui/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderData extends ChangeNotifier {
  final String url_to_order_add =
      //  "http://192.168.60.196/goodpos/frontend/web/api/order/addorder";
      "http://192.168.60.186/goodpos/frontend/web/api/order/addorder";
  final String url_to_order_by_user =
      //   "http://192.168.60.196/goodpos/frontend/web/api/order/list";
      "http://192.168.60.186/goodpos/frontend/web/api/order/list";

  bool _isLoading = false;
  late List<Order> _orderitem;
  List<Order> get listorder => _orderitem;

  set listorder(List<Order> val) {
    _orderitem = val;
  }

  Future<bool> addOrder(
    String customer_id,
    List<ItemCart> listdata,
    String pay_type,
    String discount,
  ) async {
    String _user_id = "";
    String _company_id = "1";
    String _branch_id = "1";

    bool _iscomplated = false;

    String _order_date = new DateTime.now().toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getString('user_id') != null) {
    //   _user_id = prefs.getString('user_id');
    //   _company_id = prefs.getString('company_id');
    //   _branch_id = prefs.getString('branch_id');
    // }

    var jsonx = listdata
        .map((e) => {
              'product_id': e.id,
              'qty': e.qty,
              'price': e.price,
            })
        .toList();

    final Map<String, dynamic> orderData = {
      'customer_id': customer_id,
      'user_id': _user_id,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'data': jsonx,
      'discount': discount,
    };
    print('data will save order new is ${orderData}');
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_order_add),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(orderData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data added order is  ${res["data"]}');
        _iscomplated = true;
      }
    } catch (_) {
      _iscomplated = false;
      // print('cannot create order');
    }
    return _iscomplated;
  }

  Future<dynamic> fetchOrder(String user_id) async {
    // String _current_route_id = "";
    // String _company_id = "";
    // String _branch_id = "";
    // String _car_id = "";
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getString('user_id') != null) {
    //   _current_route_id = prefs.getString('emp_route_id');
    //   _company_id = prefs.getString('company_id');
    //   _branch_id = prefs.getString('branch_id');
    //   _car_id = prefs.getString('emp_car_id');
    // }

    final Map<String, dynamic> filterData = {'user_id': user_id};
    // _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_order_by_user),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<Order> data = [];
        print('data order length is ${res["data"].length}');
        //    print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          final Order productresult = Order(
            id: res['data'][i]['id'].toString(),
            order_no: res['data'][i]['order_no'].toString(),
            order_date: res['data'][i]['order_date'].toString(),
            total_amount: res['data'][i]['total_amount'].toString(),
            status: res['data'][i]['status'].toString(),
            user_id: res['data'][i]['user_id'].toString(),
          );

          //  print('data from server is ${customerresult}');
          data.add(productresult);
        }

        listorder = data;
        _isLoading = false;
        notifyListeners();
        return listorder;
      }
    } catch (_) {}
  }

  Future<List> findOrder(String query) async {
    await Future.delayed(Duration(microseconds: 500));
    return listorder
        .where((item) => item.order_no.toLowerCase().contains(query))
        .toList();
  }
}
