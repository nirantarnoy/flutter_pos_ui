import 'package:flutter/material.dart';
import 'package:flutter_pos_ui/widgets/cart.dart';
import 'package:flutter_pos_ui/widgets/productarea.dart';
import 'package:flutter_pos_ui/widgets/responsive.dart';
import 'package:flutter_pos_ui/widgets/sidebar.dart';

class PosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Responsive(
          mobile: Row(
            children: <Widget>[
              Expanded(
                child: Productarea(),
              ),
            ],
          ),
          tablet: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Productarea(),
              ),
              Expanded(
                flex: 2,
                child: Cartarea(),
              ),
            ],
          ),
          desktop: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Sidebar(),
              ),
              Expanded(
                flex: 4,
                child: Productarea(),
              ),
              Expanded(
                flex: 2,
                child: Cartarea(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
