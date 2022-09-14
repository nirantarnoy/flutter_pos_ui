import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_pos_ui/models/product_group_menu.dart';
import 'package:flutter_pos_ui/models/products.dart';
import 'package:flutter_pos_ui/providers/productgroup.dart';
import 'package:flutter_pos_ui/providers/products.dart';
import 'package:flutter_pos_ui/widgets/sidebar.dart';
import 'package:provider/provider.dart';

class Productarea extends StatefulWidget {
  const Productarea({Key? key}) : super(key: key);

  @override
  State<Productarea> createState() => _ProductareaState();
}

class _ProductareaState extends State<Productarea> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  bool _btconnect = false;

  // List<Map<String, dynamic>> _listmenu = [
  //   {"name": "ขายดี", "active": true},
  //   {"name": "เบ็ดเตล็ด", "active": false},
  //   {"name": "เครื่องดื่ม", "active": false},
  //   {"name": "ซักผ้า", "active": false},
  //   {"name": "ยา", "active": false},
  //   {"name": "เครื่องครัว", "active": false},
  //   {"name": "อื่นๆ", "active": false},
  // ];
//  List<String> _listmenu = ["ขายดี", "เบ็ดเตล็ด"];

  @override
  void initState() {
    _btconnect = printerstatus();
    Provider.of<ProductgroupData>(context, listen: false).fetchProductgroup();
    Provider.of<ProductData>(context, listen: false).fetchProducts('โปรโมชั่น');
    super.initState();
  }

  bool printerstatus() {
    bool _status = false;
    bluetooth.isConnected.then((isConnected) {
      if (isConnected!) {
        _status = true;
      } else {
        _status = false;
      }
    });
    print('printer status is ${_status}');
    return _status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 200,
        ),
        child: Sidebar(),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.black54,
                                ),
                                onPressed: () {
                                  _scaffoldKey.currentState!.openDrawer();
                                },
                              ),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: 'G',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'POS',
                                    style: TextStyle(
                                      color: Colors.lightGreen,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          height: 40,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                gapPadding: 1,
                              ),
                              hintText: "ค้นหาที่นี่",
                              hintStyle: TextStyle(
                                  fontSize: 12, color: Colors.grey[400]),
                              fillColor: Colors.white70,
                              filled: true,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey[400],
                              ),
                              isCollapsed: true,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(''),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 80,
                  child: Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Consumer<ProductgroupData>(
                              builder: (context, _productgroup, _) =>
                                  _buildProductMenu(
                                      _productgroup.listproductgroup)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'รายการสินค้า',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: SingleChildScrollView(
              //         scrollDirection: Axis.horizontal,
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Row(
              //             children: <Widget>[
              //               Container(
              //                 height: 120,
              //                 width: 100,
              //                 margin: EdgeInsets.only(right: 5),
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(10),
              //                   color: Colors.white,
              //                 ),
              //                 child: Center(
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(8.0),
              //                     child: Image.asset('assets/images/01.png'),
              //                   ),
              //                 ),
              //               ),
              //               Container(
              //                 height: 120,
              //                 width: 100,
              //                 margin: EdgeInsets.only(right: 5),
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(10),
              //                   color: Colors.white,
              //                 ),
              //                 child: Center(
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(8.0),
              //                     child: Image.asset('assets/images/02.png'),
              //                   ),
              //                 ),
              //               ),
              //               Container(
              //                 height: 120,
              //                 width: 100,
              //                 margin: EdgeInsets.only(right: 5),
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(10),
              //                   color: Colors.white,
              //                 ),
              //                 child: Center(
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(8.0),
              //                     child: Image.asset('assets/images/02.png'),
              //                   ),
              //                 ),
              //               ),
              //               Container(
              //                 height: 120,
              //                 width: 100,
              //                 margin: EdgeInsets.only(right: 5),
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(10),
              //                   color: Colors.white,
              //                 ),
              //                 child: Center(
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(8.0),
              //                     child: Image.asset('assets/images/02.png'),
              //                   ),
              //                 ),
              //               ),
              //               Container(
              //                 height: 120,
              //                 width: 100,
              //                 margin: EdgeInsets.only(right: 5),
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(10),
              //                   color: Colors.white,
              //                 ),
              //                 child: Center(
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(8.0),
              //                     child: Image.asset('assets/images/01.png'),
              //                   ),
              //                 ),
              //               ),
              //               Container(
              //                 height: 120,
              //                 width: 100,
              //                 margin: EdgeInsets.only(right: 5),
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(10),
              //                   color: Colors.white,
              //                 ),
              //                 child: Center(
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(8.0),
              //                     child: Image.asset('assets/images/02.png'),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // Container(
              //   height: 120,
              //   child: Expanded(
              //     flex: 1,
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: SingleChildScrollView(
              //         scrollDirection: Axis.horizontal,
              //         child: Row(
              //           children: <Widget>[
              //             Consumer<ProductData>(
              //                 builder: (context, _product, _) =>
              //                     _buildProducts(_product.listproduct)),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                // height: 270,
                width: double.infinity,
                child: Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<ProductData>(
                          builder: (context, _product, _) =>
                              _buildProductgrid(_product.listproduct)),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Container(
          //       color: Colors.white,
          //       width: double.infinity,
          //       margin: EdgeInsets.only(
          //         right: 1.0,
          //       ),
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Row(
          //           children: <Widget>[
          //             Expanded(
          //               flex: 4,
          //               child: Row(
          //                 children: <Widget>[
          //                   CircleAvatar(
          //                     backgroundColor: Colors.lightGreen,
          //                     child: Icon(
          //                       Icons.person,
          //                       color: Colors.white,
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     width: 5,
          //                   ),
          //                   Text('Admin'),
          //                 ],
          //               ),
          //             ),
          //             // Expanded(
          //             //   flex: 1,
          //             //   child: Row(
          //             //       mainAxisAlignment: MainAxisAlignment.end,
          //             //       children: <Widget>[
          //             //         Icon(
          //             //           _btconnect == true
          //             //               ? Icons.print_rounded
          //             //               : Icons.print_disabled_rounded,
          //             //           color: _btconnect == true
          //             //               ? Colors.lightGreen
          //             //               : Colors.red,
          //             //         ),
          //             //         Text('connect is ${_btconnect}'),
          //             //       ]),
          //             // ),
          //           ],
          //         ),
          //       )),
          // ),
        ],
      ),
    );
  }

  Widget _buildProductMenu(List<ProductGroupMenu> menu) {
    print('list count is ${menu.length}');
    Widget listItems;

    if (menu.isNotEmpty) {
      listItems = new ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: menu.length,
          itemBuilder: (BuildContext context, int index) {
            // return GestureDetector(
            //   child: ListTile(
            //     title: Text('odod'),
            //   ),
            // );
            return GestureDetector(
                child: Container(
                  height: 20,
                  width: 80,
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: menu[index].isactive == true
                        ? Colors.lightGreen
                        : Colors.white,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${menu[index].name}',
                          style: TextStyle(
                            color: menu[index].isactive == true
                                ? Colors.white
                                : Colors.black87,
                          )),
                    ),
                  ),
                ),
                onTap: () {
                  menu.forEach((element) {
                    if (element.name == menu[index].name) {
                      setState(() {
                        element.isactive = true;
                      });
                    } else {
                      element.isactive = false;
                    }
                  });
                  setState(() {
                    Provider.of<ProductData>(context, listen: false)
                        .fetchProducts('${menu[index].name}');
                  });
                });
          });
      return listItems;
    } else {
      return Center(
        child: Text('ไม่พบรายการ'),
      );
    }
  }

  Widget _buildProducts(List<Products> products) {
    print('list count is ${products.length}');
    Widget listItems;

    if (products.isNotEmpty) {
      listItems = new ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) {
            // return GestureDetector(
            //   child: ListTile(
            //     title: Text('odod'),
            //   ),
            // );
            return GestureDetector(
                child: Container(
                  height: 120,
                  width: 100,
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/images/02.png'),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Text(
                          '${products[index].name}',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {});
          });
      return listItems;
    } else {
      return Center(
        child: Text(''),
      );
    }
  }

  Widget _buildProductgrid(List<Products> products) {
    print('list count is ${products.length}');
    Widget listItems;

    if (products.isNotEmpty) {
      listItems = GridView.builder(
        shrinkWrap: true,
        itemCount: products.length,
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: Container(
                height: 120,
                width: 100,
                // margin: EdgeInsets.only(right: 5, top: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/02.png'),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        '${products[index].name}',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Provider.of<ProductData>(context, listen: false).addCartItem(
                    products[index].id,
                    products[index].name,
                    "1",
                    products[index].price);
                // int x = Provider.of<ProductData>(context, listen: false)
                //     .orderItems
                //     .length;
                // print('item cart is ${x}');
                Scaffold.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(milliseconds: 300),
                  content: Row(
                    children: <Widget>[
                      Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "เพิ่มรายการสินค้าแล้ว",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.green,
                ));
              });
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 1.0,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
      );
      return listItems;
    } else {
      return Center(
        child: Text(''),
      );
    }
  }
}
