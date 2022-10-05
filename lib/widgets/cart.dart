import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_ui/models/itemcart.dart';
import 'package:flutter_pos_ui/providers/order.dart';
import 'package:flutter_pos_ui/providers/products.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Cartarea extends StatefulWidget {
  @override
  State<Cartarea> createState() => _CartareaState();
}

class _CartareaState extends State<Cartarea> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  final TextEditingController _transferqtyController = TextEditingController();
  double _beforechange = 0;
  List<ItemCart> listdata = [];
  bool _btconnected = false;
  double _payamount = 0;
  double _changeamount = 0;

  ItemCart _items = ItemCart(
    code: 'A01',
    name: 'น้ำยาล้างจาน',
    qty: '2',
    price: 5,
    line_discount: '0',
  );

  @override
  initState() {
    _btconnected = printerstatus();
    _payamount = 0;
    super.initState();
  }

  void paycalculate(double pay) {
    setState(() {
      _payamount += pay;
    });
  }

  bool printerstatus() {
    bool _status = true;
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

  Widget _buildordersList(List<ItemCart> orders) {
    //final orderdata = Provider.of<OrderData>(context, listen: false);
    var formatter2 = NumberFormat('#,##,##0.#');
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.75;

    Widget orderCards;
    if (orders.length > 0) {
      // print("has list");
      // return Text('${orders[0].name}');
      orderCards = ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: ValueKey(orders[index]),
            background: Container(
              color: Theme.of(context).errorColor,
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 30,
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(right: 10),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            ),
            // secondaryBackground: Container(
            //   color: Colors.lightGreen,
            //   child: Icon(
            //     Icons.delete,
            //     color: Colors.white,
            //     size: 40,
            //   ),
            //   alignment: Alignment.centerRight,
            //   padding: EdgeInsets.only(right: 20),
            //   margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            // ),
            direction: DismissDirection.startToEnd,
            confirmDismiss: (direction) {
              return showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(
                                50,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.question_mark_rounded,
                                size: 35,
                                color: Colors.lightGreen,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                            'ยืนยันการทำรายการ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                            'ต้องการลบรายการนี้ใช่หรือไม่',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: MaterialButton(
                                  color: Colors.lightGreen,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  onPressed: () {
                                    Provider.of<ProductData>(context,
                                            listen: false)
                                        .removecartitem(index);
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('ใช่'),
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                child: MaterialButton(
                                  color: Colors.red[500],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('ไม่ใช่'),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            onDismissed: (direction) {
              Provider.of<ProductData>(context, listen: false)
                  .removecartitem(index);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                      "ทำรายการสำเร็จ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
              ));
            },
            child: GestureDetector(
              onTap: () {},
              onLongPress: () {},
              child: Column(
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 5),
                    dense: true,
                    // leading: Chip(
                    //   label: Text("${orders[index].code}",
                    //       style: TextStyle(color: Colors.white)),
                    //   backgroundColor: Colors.orange[700],
                    // ),
                    title: Text(
                      "${orders[index].name}",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    // subtitle: Text(
                    //   "${orders[index].name}",
                    //   style: TextStyle(fontSize: 5, color: Colors.black),
                    // ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${orders[index].qty}x${orders[index].price}",
                          style:
                              TextStyle(fontSize: 11, color: Colors.cyan[700]),
                        ),
                        Text(
                          "${double.parse(orders[index].price.toString()) * double.parse(orders[index].qty.toString())}",
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
          );
        },
      );
      return orderCards;
    } else {
      return Center(
        child: Text(
          "ไม่พบรายการ",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      );
    }
  }

  Widget _buildordersList2(List<ItemCart> orders) {
    //final orderdata = Provider.of<OrderData>(context, listen: false);
    var formatter2 = NumberFormat('#,##,##0.#');
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.75;

    Widget orderCards;
    if (orders.length > 0) {
      // print("has list");
      // return Text('${orders[0].name}');
      orderCards = ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: ValueKey(orders[index]),
            background: Container(
              color: Theme.of(context).errorColor,
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 30,
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(right: 10),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            ),
            // secondaryBackground: Container(
            //   color: Colors.lightGreen,
            //   child: Icon(
            //     Icons.delete,
            //     color: Colors.white,
            //     size: 40,
            //   ),
            //   alignment: Alignment.centerRight,
            //   padding: EdgeInsets.only(right: 20),
            //   margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            // ),
            direction: DismissDirection.startToEnd,
            confirmDismiss: (direction) {
              return showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('แจ้งเตือน'),
                  content: Text('ต้องการลบข้อมูลใช่หรือไม่'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('ยืนยัน'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('ไม่'),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) {
              // print('delete is ${orders[index].line_id}');
              // setState(() {
              //   Provider.of<OrderData>(context, listen: false)
              //       .removeOrderDetail(orders[index].line_id);
              //   orders.removeAt(index);
              // });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                      "ทำรายการสำเร็จ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
              ));
            },
            child: GestureDetector(
              onTap: () {},
              onLongPress: () {},
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${orders[index].name}',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          // color: Colors.purple,
                          width: 40,
                          height: 40,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (int.parse(_transferqtyController.text) !=
                                      0) {
                                    var new_value = 0;
                                    new_value =
                                        int.parse(_transferqtyController.text) -
                                            1;
                                    _transferqtyController.text =
                                        new_value.toString();
                                  }
                                  // _transferqtyController.text = new_value.toString();
                                });
                              }),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 20,
                          width: 40,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 12),
                            controller: _transferqtyController,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onEditingComplete: () {},
                            onTap: () {
                              setState(() {
                                _beforechange =
                                    double.parse(_transferqtyController.text);
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: Container(
                          // color: Colors.purple,
                          width: 40,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                var new_value = 0;
                                new_value =
                                    int.parse(_transferqtyController.text) + 1;
                                _transferqtyController.text =
                                    new_value.toString();
                              });

                              // if (double.parse(_transferqtyController.text) >
                              //     double.parse(widget._avl_qty)) {
                              //   return showDialog(
                              //       context: context,
                              //       builder: (context) {
                              //         return AlertDialog(
                              //           title: Text('แจ้งเตือน'),
                              //           content:
                              //               Text('จำนวนไม่พอสำหรับการทำรายการ'),
                              //           actions: <Widget>[
                              //             FlatButton(
                              //                 onPressed: () {
                              //                   _transferqtyController.text =
                              //                       widget._avl_qty;
                              //                   Provider.of<IssueData>(context,
                              //                           listen: false)
                              //                       .updateTotalUp(
                              //                           widget._id,
                              //                           _transferqtyController
                              //                               .text);
                              //                   Navigator.of(context).pop();
                              //                 },
                              //                 child: Text('ตกลง'))
                              //           ],
                              //         );
                              //       });
                              // }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
          );
        },
      );
      return orderCards;
    } else {
      return Center(
        child: Text(
          "ไม่พบรายการ",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // listdata.add(_items);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Expanded(
                        child: Text(
                          'รายการขายตอนนี้',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black54),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Consumer<ProductData>(
                            builder: (context, _orderitems, _) => _orderitems
                                        .orderItems.length >
                                    0
                                ? ElevatedButton(
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0)),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.grey[300]),
                                    ),
                                    child: Text('ล้างทั้งหมด',
                                        style: TextStyle(
                                          fontSize: 11.0,
                                          color: Colors.red[300],
                                        )),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Container(
                                            width: 300,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        50,
                                                      ),
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons
                                                            .question_mark_rounded,
                                                        size: 35,
                                                        color:
                                                            Colors.lightGreen,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  const Text(
                                                    'ยืนยันการทำรายการ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  const Text(
                                                    'ต้องการลบรายการทั้งหมดใช่หรือไม่',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: MaterialButton(
                                                          color:
                                                              Colors.lightGreen,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                          onPressed: () {
                                                            Provider.of<ProductData>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .clearcartitem();
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false);
                                                          },
                                                          child: Text('ใช่'),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Expanded(
                                                        child: MaterialButton(
                                                          color:
                                                              Colors.red[500],
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false);
                                                          },
                                                          child: Text('ไม่ใช่'),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                : SizedBox(
                                    height: 50,
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Container(
                    child: Expanded(
                      child: Consumer<ProductData>(
                          builder: (context, _orderitems, _) {
                        listdata = _orderitems.orderItems;
                        return _buildordersList(_orderitems.orderItems);
                      }),
                    ),
                  ),
                  // _buildordersList(listdata),
                  // Column(
                  //   children: [
                  //     Expanded(
                  //       child:,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'รวม',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      )),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Consumer<ProductData>(
                                      builder: (context, _itemcarts, _) => Text(
                                        '${_itemcarts.sumCartTotal}',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'ส่วนลด',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      )),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '0.0',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'ภาษีมูลค่าเพิ่ม',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      )),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '0.0',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Divider(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey[100]),
                                    child: Center(
                                      child: Text('ใช้คูปอง',
                                          style: new TextStyle(
                                            fontSize: 11.0,
                                            color: Colors.black54,
                                          )),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Consumer<ProductData>(
                                      builder: (context, _itemcarts, _) => Text(
                                        '${_itemcarts.sumCartTotal}',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Card(
                elevation: 1,
                child: SizedBox(
                  height: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0)),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                            _btconnected == true
                                ? Colors.lightGreen
                                : Color.fromARGB(255, 255, 170, 59))),
                    child: const Text('ชำระเงิน',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            width: 700,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'ยืนยันจบการขาย',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          height: 300,
                                          child: Column(children: <Widget>[
                                            const Text(
                                              "ยอดเงิน",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black45,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 150,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                child: Consumer<ProductData>(
                                                  builder: (context, _itemcarts,
                                                          _) =>
                                                      Text(
                                                    "${_itemcarts.sumCartTotal}",
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "รับชำระ",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black45,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 150,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                child: Text(
                                                  "${_payamount}",
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "เงินทอน",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black45,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 150,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                child: Text(
                                                  "${_changeamount}",
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          height: 300,
                                          child: Column(
                                            children: [
                                              Row(children: <Widget>[
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GestureDetector(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.lightGreen,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                        ),
                                                        width: 100,
                                                        height: 50,
                                                        child: Center(
                                                            child: Text(
                                                          "1",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )),
                                                      ),
                                                      onTap: () {
                                                        print("pay 1");
                                                        setState(() {
                                                          _payamount = 1.0;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          paycalculate(2),
                                                      child: Container(
                                                        color:
                                                            Colors.lightGreen,
                                                        width: 100,
                                                        height: 50,
                                                        child: Center(
                                                            child: Text(
                                                          "2",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.lightGreen,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                                      ),
                                                      width: 100,
                                                      height: 50,
                                                      child: Center(
                                                          child: Text(
                                                        "5",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                              Row(children: <Widget>[
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      color: Colors.lightGreen,
                                                      width: 100,
                                                      height: 50,
                                                      child: Center(
                                                          child: Text(
                                                        "10",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      color: Colors.lightGreen,
                                                      width: 100,
                                                      height: 50,
                                                      child: Center(
                                                          child: Text(
                                                        "20",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      color: Colors.lightGreen,
                                                      width: 100,
                                                      height: 50,
                                                      child: Center(
                                                          child: Text(
                                                        "50",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                              Row(children: <Widget>[
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      color: Colors.lightGreen,
                                                      width: 100,
                                                      height: 50,
                                                      child: Center(
                                                          child: Text(
                                                        "100",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      color: Colors.lightGreen,
                                                      width: 100,
                                                      height: 50,
                                                      child: Center(
                                                          child: Text(
                                                        "500",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      color: Colors.lightGreen,
                                                      width: 100,
                                                      height: 50,
                                                      child: Center(
                                                          child: Text(
                                                        "1000",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                              Row(children: <Widget>[
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.lightGreen,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                                      ),
                                                      width: 100,
                                                      height: 50,
                                                      child: Center(
                                                          child: Text(
                                                        "ชำระเต็มจำนวน",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.red[500],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                                      ),
                                                      width: 100,
                                                      height: 50,
                                                      child: Center(
                                                          child: Text(
                                                        "CLEAR",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: MaterialButton(
                                          color: Colors.lightGreen,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          onPressed: () {
                                            Future<bool> result =
                                                Provider.of<OrderData>(context,
                                                        listen: false)
                                                    .addOrder("1", listdata,
                                                        "1", "0");

                                            _slipPrint(listdata);

                                            Provider.of<ProductData>(context,
                                                    listen: false)
                                                .clearcartitem();
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Text('จบการขาย'),
                                        ),
                                      ),
                                      Spacer(),
                                      Expanded(
                                        child: MaterialButton(
                                          color: Colors.grey[300],
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Text('ยกเลิก'),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _slipPrint(List<ItemCart> items) async {
    print('conntected bt');
    print('print item count is ${items.length}');
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    bluetooth.isConnected.then((isConnected) {
      if (isConnected!) {
        bluetooth.printCustom("G-POS", 3, 1);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("No: 001", "Date: 08/06/2021", 1);
        bluetooth.printLeftRight("Time: 21:45", "", 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("----------------------------", 1, 0);
        bluetooth.printLeftRight("Items", "Total", 1);
        bluetooth.printCustom("----------------------------", 1, 0);

        double total_all = 90;
        // for (int i = 0; i <= items.length - 1; i++) {
        // double line_total =
        //     double.parse(items[i].qty) * double.parse(items[i].price);
        // total_all += line_total;
        bluetooth.printLeftRight("xx", "90", 1);
        // }

        bluetooth.printCustom("------------------------------", 1, 0);
        bluetooth.printLeftRight("TOTAL", "${total_all}", 3);

        bluetooth.paperCut();
      } else {
        print('not connect bluetooth');
      }
    });
  }

  void _testPrint() async {
    print('conntected bt');
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    bluetooth.isConnected.then((isConnected) {
      if (isConnected!) {
        bluetooth.printCustom("GPOS", 3, 1);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("No: 001", "Date: 08/06/2021", 1);
        bluetooth.printLeftRight("Time: 21:45", "", 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("-----------------------------------", 1, 1);
        bluetooth.printLeftRight("Items", "Qty", 1);
        bluetooth.printCustom("-----------------------------------", 1, 1);
        bluetooth.printLeftRight("PB", "1", 1);
        bluetooth.printLeftRight("PC", "4", 1);
        bluetooth.printLeftRight("M", "3", 1);
        bluetooth.printCustom("-----------------------------------", 1, 1);
        bluetooth.printLeftRight("TOTAL", "8", 3);
        // bluetooth.printImage(pathImage);
        // bluetooth.printCustom("Body left", 1, 0);
        // bluetooth.printCustom("Body right", 1, 2);
        // bluetooth.printNewLine();
        // //  bluetooth.printCustom("ผู้ขาย", 2, 1);
        // bluetooth.printNewLine();
        // bluetooth.printQRcode("Insert Your Own Text to Generate", 10, 10, 1);
        // bluetooth.printNewLine();
        // bluetooth.printNewLine();
        bluetooth.paperCut();
      } else {
        print('not connect bluetooth');
      }
    });
    // bluetooth.isConnected.then((isConnected) {
    //   if (isConnected) {
    //     bluetooth.printCustom("HEADER", 3, 1);
    //     bluetooth.printNewLine();
    //     //    bluetooth.printImage(pathImage);
    //     bluetooth.printNewLine();
    //     bluetooth.printLeftRight("LEFT", "RIGHT", 0);
    //     bluetooth.printLeftRight("LEFT", "RIGHT", 1);
    //     bluetooth.printNewLine();
    //     bluetooth.printLeftRight("LEFT", "RIGHT", 2);
    //     bluetooth.printCustom("Body left", 1, 0);
    //     bluetooth.printCustom("Body right", 0, 2);
    //     bluetooth.printNewLine();
    //     bluetooth.printCustom("Terimakasih", 2, 1);
    //     bluetooth.printNewLine();
    //     bluetooth.printQRcode("Insert Your Own Text to Generate", 10, 10, 1);
    //     bluetooth.printNewLine();
    //     bluetooth.printNewLine();
    //     bluetooth.paperCut();
    //   }
    // });
  }
}
