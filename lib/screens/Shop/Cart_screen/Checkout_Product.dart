import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckoutProduct extends StatefulWidget {
  @override
  _CheckoutProductState createState() => _CheckoutProductState();
}

class _CheckoutProductState extends State<CheckoutProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: true,
        backgroundColor: Colors.grey[200],
        title: Text(
          'Checkout',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      'Delivery',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Table(
                          defaultColumnWidth: FixedColumnWidth(120.0),
                          border: TableBorder.all(
                            color: Colors.grey,
                          ),
                          children: [
                            TableRow(
                                decoration: BoxDecoration(color: Colors.white),
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('Home Delivery',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(
                                        width: 140,
                                        height: 40,
                                      ),
                                      Text(
                                        'change',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  )
                                ]),
                            TableRow(
                                decoration: BoxDecoration(color: Colors.white),
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/Map.png',
                                        width: 70,
                                        height: 60,
                                      ),
                                      SizedBox(
                                        width: 70,
                                        height: 70,
                                      ),
                                      Text('85 street, West London'),
                                    ],
                                  )
                                ])
                          ]),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      'Order',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      width: MediaQuery.of(context).size.width * 0.75,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      'T-Shirt blue pattern',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '50(x1)',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Order',
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '50\$',
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Coupon Discount',
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '-5\$',
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Tax',
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '5\$',
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Delivery fee',
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '19\$',
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Total',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '69\$',
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(250, 50),
                    primary: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Proceed to Payment',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

BottomSheet(BuildContext context) {
  return showModalBottomSheet(
      elevation: 5,
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'SELECT OPTION',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w800),
                      )
                    ],
                  )),
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(width: 30,),
                      PaymentMethod('COD', Icons.home_outlined),
                      SizedBox(
                        width: 30,
                      ),
                      PaymentMethod('Razorpay', Icons.payment_outlined),
                    ],
                  ))
            ],
          ),
        );
      });
}

class PaymentMethod extends StatelessWidget {
  String Description;
  IconData icon;

  PaymentMethod(
    this.Description,
    this.icon,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 150,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon), // icon
            Text("$Description"), // text
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  String describe;
  Function() Pressed;
  CustomButton(
    this.describe,
    this.Pressed,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.only(bottom: 25),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            elevation: 7,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            )),
        onPressed: () {
          Pressed();
          //BottomSheet(context);
        },
        child: Text(
          '$describe',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
