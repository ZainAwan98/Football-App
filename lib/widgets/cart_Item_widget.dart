import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartItemWidget extends StatelessWidget {
  bool isChecked;
  Function onChanged;
  String imageUrl;
  String itemName;
  String itemDescription;
  String itemCount;
  String itemPrice;
  Function onMinusPressed;
  Function onPlusPressed;
  Widget checkBox;

  CartItemWidget(
      {this.isChecked,
      this.onChanged,
      this.imageUrl,
      this.itemName,
      this.itemDescription,
      this.itemCount,
      this.itemPrice,
      this.onMinusPressed,
      this.onPlusPressed,
      this.checkBox});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 0, 0),
              child: SizedBox(
                height: 30,
                width: 30,
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  elevation: 2,
                  color: isChecked ? Colors.blue : Colors.grey.shade300,
                  child: Checkbox(
                    value: isChecked,
                    onChanged: onChanged,
                    checkColor: Color.fromARGB(255, 255, 255, 255),
                    // side: BorderSide(color: Color),
                    activeColor: Colors.transparent,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
              child: Container(
                height: 80,
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Text(
                  imageUrl,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 0, 0),
                  child: Text(
                    itemName,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 0, 0),
                  child: Text(
                    itemDescription,
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 0, 0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            elevation: 2,
                            color: Colors.blue,
                            child: Icon(
                              FontAwesomeIcons.minus,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Text(
                          itemCount,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),
                      InkWell(
                        onTap: onMinusPressed,
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            elevation: 2,
                            color: Colors.blue,
                            child: Icon(
                              FontAwesomeIcons.plus,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 50,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                  child: Text(
                    itemPrice,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: IconButton(
                      onPressed: onPlusPressed,
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.blue,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
