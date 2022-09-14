import 'package:flutter/material.dart';
import 'package:flutter_pos_ui/pages/auth.dart';
import 'package:flutter_pos_ui/pages/pospage.dart';
import 'package:flutter_pos_ui/pages/product.dart';
import 'package:flutter_pos_ui/providers/order.dart';
import 'package:flutter_pos_ui/providers/productgroup.dart';
import 'package:flutter_pos_ui/providers/products.dart';
import 'package:flutter_pos_ui/providers/user.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductgroupData>.value(
            value: ProductgroupData()),
        ChangeNotifierProvider<ProductData>.value(value: ProductData()),
        ChangeNotifierProvider<OrderData>.value(value: OrderData()),
        ChangeNotifierProvider<UserData>.value(value: UserData()),
      ],
      child: MaterialApp(
        title: 'GPOS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Kanit-Regular',
        ),
        home: PosPage(),
      ),
    );
  }
}
