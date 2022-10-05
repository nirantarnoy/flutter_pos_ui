import 'package:flutter/material.dart';
import 'package:flutter_pos_ui/pages/blue_print.dart';
import 'package:flutter_pos_ui/pages/order.dart';
import 'package:flutter_pos_ui/pages/product.dart';
import 'package:flutter_pos_ui/pages/systemconfig.dart';

class Sidebar extends StatefulWidget {
  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _logout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 12,
              ),
              Icon(
                Icons.privacy_tip_outlined,
                size: 32,
                color: Colors.lightGreen,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'ยืนยันการทำรายการ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'ต้องการออกจากระบบใช่หรือไม่',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      color: Colors.lightGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      onPressed: () {},
                      child: Text('ใช่'),
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    child: MaterialButton(
                      color: Colors.grey[400],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  // Icon(Icons.person, size: 30, color: Colors.blueGrey),
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
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              GestureDetector(
                child: ListTile(
                  leading: Icon(
                    Icons.donut_small,
                  ),
                  title: Text('รายการขาย'),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPage(),
                  ),
                ),
              ),
              GestureDetector(
                child: ListTile(
                  leading: Icon(
                    Icons.crop_free_outlined,
                  ),
                  title: Text('สินค้า'),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductPage(),
                  ),
                ),
              ),
              GestureDetector(
                child: ListTile(
                  leading: Icon(
                    Icons.exposure,
                  ),
                  title: Text('สต๊อกสินค้า'),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SystemconfigPage(),
                  ),
                ),
              ),
              GestureDetector(
                child: ListTile(
                  leading: Icon(
                    Icons.person_add_alt,
                  ),
                  title: Text('สมาชิก'),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SystemconfigPage(),
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.person,
                ),
                title: Text('ผู้ใช้งาน'),
              ),
              GestureDetector(
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                  ),
                  title: Text('ตั้งค่า'),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SystemconfigPage(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
                child: SizedBox(
                  height: 30,
                  width: 150,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0)),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightGreen),
                      ),
                      child: new Text('ออกจากระบบ',
                          style: new TextStyle(
                              fontSize: 12.0, color: Colors.white)),
                      onPressed: () => _logout()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
