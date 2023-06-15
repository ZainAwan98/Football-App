import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartInfoWidget extends StatelessWidget {
  String title;
  String amount;
  CartInfoWidget({this.title, this.amount});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: title == 'Total' ? 25 : 15),
              )),
          Spacer(),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Text(
                amount,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: title == 'Total' ? 25 : 15),
              )),
        ],
      ),
    );
  }
}
