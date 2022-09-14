import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pos_ui/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserData with ChangeNotifier {
  final String url_to_user_login =
      //  "http://192.168.1.120/icesystem/frontend/web/api/authen/login";
      // "http://103.253.73.108/icesystem/frontend/web/api/authen/login";
      // "http://103.253.73.108/icesystem/frontend/web/api/authen/login";
      "http://103.253.73.108/icesystem/frontend/web/api/authen/login";
  final String url_to_user_login_qrcode =
      //  "http://192.168.1.120/icesystem/frontend/web/api/authen/login";
      // "http://103.253.73.108/icesystem/frontend/web/api/authen/login";
      // "http://103.253.73.108/icesystem/frontend/web/api/authen/login";
      "http://103.253.73.108/icesystem/frontend/web/api/authen/loginqrcode";

  late User _authenticatedUser;
  late Timer _authTimer;

  late List<User> _user;
  late List<User> _userlogin;
  List<User> get listuser => _user;
  List<User> get listuserlogin => _userlogin;
  bool _isLoading = false;
  bool _isauthenuser = false;

  int _id = 0;
  int get idUser => _id;

  String _route_type = "1";
  String get routeType => _route_type;

  set idUser(int val) {
    _id = val;
    notifyListeners();
  }

  set routeType(String val) {
    _route_type = val;
    notifyListeners();
  }

  set listuser(List<User> val) {
    _user = val;
    notifyListeners();
  }

  set listuserlogin(List<User> val) {
    _userlogin = val;
    notifyListeners();
  }

  bool get is_loading {
    return _isLoading;
  }

  bool get is_authenuser {
    return _isauthenuser;
  }

  Future<dynamic> login(String username, String password) async {
    final Map<String, dynamic> loginData = {
      'username': username,
      'password': password
    };
    //   print(username);
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_user_login),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(loginData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<User> data = [];
        print('user login is ${res["data"].length}');
        print('data user is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }

        final User userresult = User(
          id: res['data'][0]['user_id'].toString(),
          username: res['data'][0]['username'].toString(),
          emp_code: res['data'][0]['emp_code'].toString(),
          emp_name: res['data'][0]['emp_name'].toString(),
          emp_photo: res['data'][0]['emp_photo'].toString(),
          company_id: res['data'][0]['company_id'].toString(),
          branch_id: res['data'][0]['branch_id'].toString(),
        );

        data.add(userresult);

        final DateTime now = DateTime.now();
        final DateTime expiryTime = now.add(Duration(seconds: 160000));
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('user_id', res['data'][0]['user_id'].toString());
        prefs.setString('emp_code', res['data'][0]['emp_code'].toString());
        prefs.setString('emp_name', res['data'][0]['emp_name'].toString());
        prefs.setString('emp_photo', res['data'][0]['emp_photo'].toString());
        prefs.setString('company_id', res['data'][0]['company_id'].toString());
        prefs.setString('branch_id', res['data'][0]['branch_id'].toString());
        //  prefs.setString('route_type', res['data'][0]['route_type'].toString());
        prefs.setString('expiryTime', expiryTime.toIso8601String());
        prefs.setString('working_mode', 'online');
        // set route type

        listuserlogin = data;
        _isauthenuser = true;
        _isLoading = false;
        return listuserlogin;
      } else {
        print('server not status 200');
      }
    } catch (_) {
      _isauthenuser = false;
    }
  }

  Future<dynamic> loginwithqr(String car, String driver, String memeber) async {
    final Map<String, dynamic> loginData = {
      'car': car,
      'driver': driver,
      'password': '',
      'member': memeber
    };
    print(loginData);
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_user_login_qrcode),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(loginData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<User> data = [];
        print('user login is ${res["data"].length}');
        print('data user is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }

        final User userresult = User(
          id: res['data'][0]['user_id'].toString(),
          username: res['data'][0]['username'].toString(),
          emp_code: res['data'][0]['emp_code'].toString(),
          emp_name: res['data'][0]['emp_name'].toString(),
          emp_photo: res['data'][0]['emp_photo'].toString(),
          company_id: res['data'][0]['company_id'].toString(),
          branch_id: res['data'][0]['branch_id'].toString(),
        );

        data.add(userresult);

        final DateTime now = DateTime.now();
        final DateTime expiryTime = now.add(Duration(seconds: 160000));
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('user_id', res['data'][0]['user_id'].toString());
        prefs.setString('emp_code', res['data'][0]['emp_code'].toString());
        prefs.setString('emp_name', res['data'][0]['emp_name'].toString());
        prefs.setString('emp_photo', res['data'][0]['emp_photo'].toString());
        prefs.setString('company_id', res['data'][0]['company_id'].toString());
        prefs.setString('branch_id', res['data'][0]['branch_id'].toString());
        // prefs.setString('route_type', res['data'][0]['route_type'].toString());

        prefs.setString('expiryTime', expiryTime.toIso8601String());
        prefs.setString('working_mode', 'online');

        listuserlogin = data;
        _isauthenuser = true;
        _isLoading = false;
        return listuserlogin;
      } else {
        print('server not status 200');
      }
    } catch (_) {
      _isauthenuser = false;
    }
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');

    final DateTime now = DateTime.now();
    final parsedExpiryTime = DateTime.parse(expiryTimeString);
    if (parsedExpiryTime.isBefore(now)) {
      //_authenticatedUser = null;
      notifyListeners();
      return;
    }
    final String emp_code = prefs.getString('emp_code');
    final String emp_name = prefs.getString('emp_name');
    final String userId = prefs.getString('user_id');
    final String emp_photo = prefs.getString('user_photo');
    final String company_id = prefs.getString('company_id');
    final String branch_id = prefs.getString('branch_id');
    final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
    _authenticatedUser = User(
        id: userId,
        emp_code: emp_code,
        emp_name: emp_name,
        emp_photo: emp_photo,
        username: "",
        company_id: company_id,
        branch_id: branch_id);
    _isauthenuser = true;
    setAuthTimeout(tokenLifespan);
    notifyListeners();
  }

  Future<User> getUserAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    late User _currentinfo;
    if (prefs.getString('user_id') != null) {
      _currentinfo = User(
          id: prefs.getString('userId'),
          emp_code: prefs.getString('emp_code'),
          emp_name: prefs.getString('emp_name'),
          emp_photo: prefs.getString('emp_photo'),
          username: "",
          company_id: prefs.getString('company_id'),
          branch_id: prefs.getString('branch_id'));
      return _currentinfo;
    } else {
      _currentinfo = User(
          id: "",
          emp_code: "",
          emp_name: "",
          emp_photo: "",
          username: "",
          company_id: "",
          branch_id: "");
      return _currentinfo;
    }
  }

  Future<Map<String, dynamic>> logout() async {
    _authenticatedUser = null as User;
    _isauthenuser = false;
    _authTimer.cancel();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // prefs.remove('token');
    // prefs.remove('username');
    // prefs.remove('userId');
    // prefs.remove('studentId');
    _isLoading = false;
    return {'success': true};
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}
