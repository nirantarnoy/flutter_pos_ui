import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("สินค้า"),
      ),
      body: Row(children: <Widget>[
        Expanded(
          flex: 4,
          child: Text("รายการสินค้า"),
        ),
        Expanded(
          flex: 2,
          child: Text("รายละเอียด"),
        ),
      ]),
    );
  }
}
