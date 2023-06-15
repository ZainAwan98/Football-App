import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myteam/model/categoriesModel.dart';
import 'package:myteam/model/productsModel.dart';
import 'package:myteam/provider/cartProvider.dart';
import 'package:myteam/provider/categories_provider.dart.dart';
import 'package:myteam/provider/products_provider.dart';
import 'package:myteam/screens/loading.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Cart_screen/Select_Product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:badges/badges.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool Color_index = false;
  ScrollController _scrollController;
  ProductsProvider allProductsProvider;
  List<CategoriesData> categoriesProducts;

  List<AllProductsModel> allProducts;
  ShopCategoriesProvider categoriesData;

  CartProvider cartProvider;

  @override
  void initState() {
    allProductsProvider = Provider.of<ProductsProvider>(context, listen: false);

    categoriesData =
        Provider.of<ShopCategoriesProvider>(context, listen: false);

    cartProvider = Provider.of<CartProvider>(context, listen: false);

    cartProvider.getcartItemsCount();
    getScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    allProductsProvider
        .getProducts(context, allProductsProvider.page, false)
        .then((value) {
      allProducts = allProductsProvider.allProductsData;
    });

    categoriesData.getCategories(context).then((value) {
      categoriesProducts = categoriesData.categoriesData;
    });
    super.didChangeDependencies();
  }

  getScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (allProductsProvider.isLoading == false) {
          allProductsProvider
              .getProducts(context, allProductsProvider.page, true)
              .then((value) {
            allProducts = value;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    allProductsProvider.setPageCountToZero();
    allProductsProvider.resetAllProducts();
    cartProvider.resetCartItemsCount();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // allProductsData.getProducts(context, allProductsData.page);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.only(left: 20, top: 40),
                  height: 50,
                  width: 40,
                  child: Material(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    child: TextField(
                      expands: false,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          fillColor: Colors.grey,
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: false),
                    ),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 25, top: 40, right: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        )
                      ]),
                  height: 50,
                  width: 40,
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/images/category.png',
                      color: Colors.blue,
                    ),
                  )),
              Consumer<CartProvider>(builder: (context, cartProvider, _) {
                return Expanded(
                  flex: 2,
                  child: Container(
                      margin: EdgeInsets.only(left: 25, top: 40, right: 35),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            )
                          ]),
                      height: 50,
                      width: 7,
                      child: Badge(
                        badgeContent: Text(
                          cartProvider.countCartItems.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        badgeColor: Colors.blue,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/cart");
                          },
                          icon: Image.asset(
                            'assets/images/cart.png',
                          ),
                        ),
                      )),
                );
              }),
            ],
          ),
          Consumer<ShopCategoriesProvider>(
              builder: (context, shopCategories, _) {
            return shopCategories.isLoading
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: LoadingWidget())
                : Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Row(
                      children: [
                        Container(
                            height: 70,
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                              itemCount: categoriesProducts.length,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 100,
                                childAspectRatio: 1.8 / 2,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, index) {
                                return Column(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (categoriesProducts[index]
                                                      .id ==
                                                  0) {
                                                allProductsProvider
                                                    .setPageCountToZero();
                                                allProductsProvider
                                                    .getProducts(
                                                        context,
                                                        allProductsProvider
                                                            .page,
                                                        false)
                                                    .then((value) {
                                                  allProducts =
                                                      allProductsProvider
                                                          .allProductsData;
                                                });
                                              } else {
                                                allProductsProvider
                                                    .setPageCountToZero();
                                                allProductsProvider
                                                    .productsById(
                                                        context,
                                                        categoriesProducts[
                                                                index]
                                                            .id,
                                                        false)
                                                    .then((value) => allProducts =
                                                        allProductsProvider
                                                            .allProductsData);
                                              }
                                            },
                                            child: Container(
                                              width: 70,
                                              child: CircleAvatar(
                                                radius: 70,
                                                backgroundColor: Colors.indigo,
                                                child: Icon(
                                                  Icons
                                                      .local_grocery_store_sharp,
                                                  color: Colors.lightBlue,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${categoriesProducts[index].name}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ))
                                  ],
                                );
                              },
                            )),
                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   height: MediaQuery.of(context).size.height,
                        //
                        // )
                      ],
                    ),
                  );
          }),
          Consumer<ProductsProvider>(builder: (context, productsProvider, _) {
            return productsProvider.isFirstLoading
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                    child: LoadingWidget(),
                  )
                : Expanded(
                    flex: 6,
                    child: Row(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: GridView.builder(
                              controller: _scrollController,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      childAspectRatio: 1.7 / 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 17),
                              itemCount: allProducts.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return Container(
                                    height: 400,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 3,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          )
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 30),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SelectProduct(
                                                                  productDetails: [
                                                                    allProducts[
                                                                        index]
                                                                  ],
                                                                )),
                                                      );
                                                    },
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          allProducts[index]
                                                              .image,
                                                      placeholder:
                                                          (context, url) =>
                                                              LoadingWidget(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                    // Image.asset(
                                                    //   allProducts[index]
                                                    //       .image
                                                    //       .toString(),
                                                    // )
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 140, top: 20),
                                                  child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          Color_index =
                                                              !Color_index;
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.favorite,
                                                        color: Color_index
                                                            ? Colors.red
                                                            : Colors.grey,
                                                      )),
                                                ),
                                              ],
                                            )),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Text(
                                                      allProducts[index].title,
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 5, 0, 0),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Text(
                                                      allProducts[index]
                                                          .salePrice
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  Consumer<CartProvider>(
                                                      builder: (context,
                                                          cartProvider, _) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          90, 0, 0, 0),
                                                      child: IconButton(
                                                        onPressed: () {
                                                          print(
                                                              '${allProducts[index]}'
                                                                  .toString());
                                                          cartProvider
                                                              .addToCart(
                                                                  allProducts[
                                                                      index]);
                                                        },
                                                        icon: Icon(
                                                            FontAwesomeIcons
                                                                .cartPlus),
                                                        color: Colors.blue,
                                                      ),
                                                    );
                                                  }),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ));
                              }),
                        ),
                      ],
                    ));
          }),
          Consumer<ProductsProvider>(builder: (context, productsProvider, _) {
            return productsProvider.isLoading
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: LoadingWidget(),
                  )
                : Container(
                    height: 0,
                    width: 0,
                  );
          }),
        ],
      ),
    );
  }
}
