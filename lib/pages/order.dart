import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_ui/models/order.dart';
import 'package:flutter_pos_ui/providers/order.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<OrderData>(context, listen: false).fetchOrder("1");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          title: const Text("รายการขาย")),
      body: Row(children: [
        Expanded(
          flex: 4,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(children: <Widget>[
                  const Text(""),
                ]),
              ),
              Expanded(
                flex: 5,
                child: Consumer<OrderData>(
                  builder: (context, _orders, _) =>
                      _buillist(_orders.listorder),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(flex: 5, child: Text('รายละเอียด')),
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {},
                          child: Text("ยกเลิก"),
                        ),
                      ),
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {},
                          child: Text("ลบ"),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buillist(List<Order> listorder) {
    Widget _listwidget;
    if (listorder.isNotEmpty) {
      _listwidget = ListView.builder(
          itemCount: listorder.length,
          itemBuilder: (BuildContext context, index) {
            return GestureDetector(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("${listorder[index].order_no}"),
                    subtitle: Text("${listorder[index].order_date}"),
                    trailing: Text("${listorder[index].total_amount}"),
                  ),
                  Divider(),
                ],
              ),
              onTap: () {},
            );
          });
      return _listwidget;
    } else {
      return Center(
        child: Text("ไม่พบรายการ"),
      );
    }
  }
}
