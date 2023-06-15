import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myteam/model/cart_items_model.dart';
import 'package:myteam/provider/cartProvider.dart';
import 'package:myteam/screens/loading.dart';
import 'package:provider/provider.dart';

import '../../widgets/cart_info_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartProvider cartProvider;
  List<CartItemsModel> _cartItems = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.resetCartItemsCount();
    cartProvider.getcart().then((value) {
      _cartItems = cartProvider.cartItems;
      if (_cartItems.isNotEmpty) {
        for (var i = 0; i <= _cartItems.length - 1; i++) {
          _selectedIndex.add(false);
        }
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    cartProvider.resetCartItemsList();
    super.dispose();
  }

  bool _isSelectedAll = false;
  List<bool> _selectedIndex = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cart',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.all(10.0),
          //         child: SizedBox(
          //           height: 30,
          //           width: 30,
          //           child: Material(
          //             shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(5)),
          //             elevation: 2,
          //             color:
          //                 _isSelectedAll ? Colors.blue : Colors.grey.shade300,
          //             child: Checkbox(
          //               value: true,
          //               onChanged: (_) {
          //                 setState(() {
          //                   _isSelectedAll = !_isSelectedAll;
          //                   if (_isSelectedAll) {
          //                     _selectedIndex.clear();
          //                     for (var i = 0; i <= 5; i++) {
          //                       _selectedIndex.add(true);
          //                     }
          //                   } else {
          //                     _selectedIndex.clear();
          //                     for (var i = 0; i <= 5; i++) {
          //                       _selectedIndex.add(false);
          //                     }
          //                   }
          //                 });
          //               },
          //               side: BorderSide.none,
          //               checkColor: Colors.white,
          //               activeColor: Colors.transparent,
          //             ),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         width: 5,
          //       ),
          //       Text('Select all'),
          //       Spacer(),
          //       IconButton(
          //           onPressed: _isSelectedAll ? () {} : () {},
          //           icon: Icon(
          //             Icons.delete_outline,
          //             color: _isSelectedAll ? Colors.blue : Colors.grey,
          //           )),
          //     ],
          //   ),
          // ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Consumer<CartProvider>(builder: (context, cartProvider, _) {
              return cartProvider.loadingCart
                  ? LoadingWidget()
                  : _cartItems == []
                      ? Text('No Items in cart')
                      : ListView.builder(
                          shrinkWrap: true,
                          // the number of items in the list
                          itemCount: _selectedIndex.length,

                          // display each item of the product list
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 150,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          5, 30, 0, 0),
                                      child: SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Material(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          elevation: 2,
                                          color: _selectedIndex[index]
                                              ? Colors.blue
                                              : Color.fromRGBO(
                                                  224, 224, 224, 1),
                                          child: Checkbox(
                                            side: BorderSide.none,
                                            value: _selectedIndex[index],
                                            onChanged: (_) {
                                              if (_selectedIndex[index] ==
                                                  false) {
                                                setState(() {
                                                  _selectedIndex[index] = true;
                                                });
                                              } else {
                                                setState(() {
                                                  _selectedIndex[index] = false;
                                                });
                                              }
                                            },
                                            checkColor: Colors.white,
                                            activeColor: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 5, 0, 0),
                                      child: Container(
                                          height: 80,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            border: Border.all(
                                                color: Colors.grey, width: 1),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: _cartItems[index].image,
                                          )),
                                    ),
                                    cartProvider.updatingCart
                                        ? Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 5, 15, 40),
                                            child: LoadingWidget(),
                                          )
                                        : Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 5, 0, 0),
                                                  child: Text(
                                                    _cartItems[index].title,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 14,
                                                        letterSpacing: 1),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 5, 0, 0),
                                                  child: Text(
                                                    'Price:${_cartItems[index].price.toString()} \$',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 5, 0, 0),
                                                  child: Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          cartProvider
                                                              .updateCart(
                                                                  _cartItems[
                                                                          index]
                                                                      .itemId,
                                                                  {
                                                                "qty":
                                                                    '${_cartItems[index].qty - 1}',
                                                              }).then((value) {
                                                            if (value) {
                                                              if (_cartItems[
                                                                          index]
                                                                      .qty ==
                                                                  1) {
                                                                cartProvider
                                                                    .removeFromCart(
                                                                        _cartItems[index]
                                                                            .itemId)
                                                                    .then(
                                                                        (value) {
                                                                  value
                                                                      ? _cartItems
                                                                          .removeAt(
                                                                              index)
                                                                      : '';
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  cartProvider
                                                                      .decreaseItemCount();
                                                                  _cartItems[
                                                                          index]
                                                                      .qty = _cartItems[
                                                                              index]
                                                                          .qty -
                                                                      1;
                                                                });
                                                              }
                                                            }
                                                          });
                                                        },
                                                        child: SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child: Material(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            elevation: 2,
                                                            color: Colors.blue,
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .minus,
                                                              size: 15,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                15, 0, 15, 0),
                                                        child: Text(
                                                          _cartItems[index]
                                                              .qty
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          cartProvider
                                                              .updateCart(
                                                                  _cartItems[
                                                                          index]
                                                                      .itemId,
                                                                  {
                                                                "qty":
                                                                    '${_cartItems[index].qty + 1}'
                                                              }).then((value) {
                                                            setState(() {
                                                              if (value) {
                                                                cartProvider
                                                                    .IncreaseItemCount();
                                                                _cartItems[index]
                                                                        .qty =
                                                                    _cartItems[index]
                                                                            .qty +
                                                                        1;
                                                              }
                                                            });
                                                          });
                                                        },
                                                        child: SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child: Material(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            elevation: 2,
                                                            color: Colors.blue,
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .plus,
                                                              size: 15,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Flexible(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 5, 0, 0),
                                            child: Text(
                                              '${_cartItems[index].subTotal.toString()} \$',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 15, 0, 0),
                                            child: IconButton(
                                                onPressed: _selectedIndex[index]
                                                    ? () {
                                                        cartProvider
                                                            .removeFromCart(
                                                                _cartItems[
                                                                        index]
                                                                    .itemId)
                                                            .then((value) {
                                                          value
                                                              ? _cartItems
                                                                  .removeAt(
                                                                      index)
                                                              : '';
                                                        });
                                                      }
                                                    : () {},
                                                icon: Icon(
                                                  Icons.delete_outline,
                                                  color: _selectedIndex[index]
                                                      ? Colors.blue
                                                      : Colors.grey,
                                                )),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Divider(
              color: Colors.grey.shade300,
              thickness: 2,
            ),
          ),
          CartInfoWidget(
            title: 'Shipping',
            amount: '\$50',
          ),
          CartInfoWidget(
            title: 'Tax',
            amount: '\$50',
          ),
          CartInfoWidget(
            title: 'Total',
            amount: '\$50',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
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
                'Checkout',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
