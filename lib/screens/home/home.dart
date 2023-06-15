import 'dart:convert' as convert;
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:line_icons/line_icons.dart';
import 'package:myteam/provider/ads_provider.dart';
import 'package:myteam/provider/theme_provider.dart';
import 'package:myteam/screens/Shop/Products_screen/Products.dart';
import 'package:myteam/screens/home/fragment/club.dart';
import 'package:myteam/screens/home/fragment/default.dart';
import 'package:myteam/screens/home/fragment/fans.dart';
import 'package:myteam/screens/home/fragment/matches.dart';
import 'package:myteam/screens/home/fragment/ranking.dart';
import 'package:myteam/screens/other/settings.dart';
import 'package:myteam/screens/post/favorites_list.dart';
import 'package:myteam/screens/splash/splash.dart';
import 'package:myteam/screens/user/login.dart';
import 'package:myteam/screens/user/profile.dart';
import 'package:need_resume/need_resume.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import '../../config/config.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ResumableState<Home> {
  Map data;
  int clickcol = 0;
  int index1 = 0;
  int index2 = 0;
  int index3 = 0;
  int index4 = 0;
  int index5 = 0;
  int index6 = 0;
  int index7=0;
  bool openMenu = false;
  List Languages = [
    {'label': 'En', 'value': 'en'},
    {'label': 'Ar', 'value': 'ar'},
    {'label': 'He', 'value': 'he'},
  ];

  PageController controller = PageController(initialPage: Config.selectedIndex);
  List<GButton> tabs = [];
  bool logged = false;
  String name = "Login to your account !".tr();
  String email = "Sign up/in now for free !".tr();
  Image image = Image.asset("assets/images/profile.jpg");

  List<Widget> fragments = [
    Default(),
    Matches(),
    Ranking(),
    Club(),
    Fans(),
  ];

  @override
  void initState() {
    super.initState();
    getLogged();
    showGDPR();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    return WillPopScope(
      onWillPop: () {
        if (openMenu) {
          setState(() {
            openMenu = false;
          });
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Stack(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Stack(
              children: <Widget>[
                Positioned(
                  width: MediaQuery.of(context).size.width,
                  right: -(MediaQuery.of(context).size.width / 3),
                  top: 85,
                  height: 400,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder(
                      future: initAppInfos(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return Opacity(
                              child: CachedNetworkImage(
                                height: 400,
                                imageUrl: snapshot.data,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.fitHeight,
                              ),
                              opacity: 0.09);
                        else
                          return Text("");
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    bottomNavigationBar: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black54.withOpacity(0.3),
                                offset: Offset(0, 0),
                                blurRadius: 5)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: SafeArea(
                          child: GNav(
                              gap: 6,
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                              activeColor:
                                  Theme.of(context).textTheme.bodyText1.color,
                              iconSize: 17,
                              textStyle: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color,
                                  fontWeight: FontWeight.w600),
                              tabBackgroundColor: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .color
                                  .withOpacity(0.1),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              duration: Duration(milliseconds: 200),
                              tabs: [
                                GButton(
                                  icon: LineIcons.home,
                                  text: 'Home'.tr(),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                GButton(
                                  icon: LineIcons.calendar,
                                  text: 'Matches'.tr(),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                GButton(
                                  icon: LineIcons.table,
                                  text: 'Ranking'.tr(),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                GButton(
                                  icon: LineIcons.alternateShield,
                                  text: 'Club'.tr(),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                GButton(
                                  icon: LineIcons.users,
                                  text: 'Fans'.tr(),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ],
                              selectedIndex: Config.selectedIndex,
                              onTabChange: (index) {
                                setState(() {
                                  Config.selectedIndex = index;
                                });
                                controller.jumpToPage(index);
                              }),
                        ),
                      ),
                    ),
                    drawer: Drawer(
                      backgroundColor: Colors.grey[100],
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          DrawerHeader(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: buildProfileItem(),
                          ),
                          Container(
                              color: clickcol == 1
                                  ? Colors.white
                                  : Colors.grey[100],
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      width: 4,
                                      height: 40,
                                      color: clickcol == 1
                                          ? Colors.red
                                          : Colors.grey[100],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 56,
                                    child: buildMenuItem("HOME PAGE".tr(),
                                        Colors.transparent, LineIcons.home, () {
                                      setState(() {
                                        Config.selectedIndex = 0;
                                        openMenu = false;
                                        clickcol = 1;
                                        index1 = index2 = index3 =
                                            index4 = index5 = index6 = 0;
                                      });
                                      controller
                                          .jumpToPage(Config.selectedIndex);
                                      Navigator.pop(context);
                                    }),
                                  )
                                ],
                              )),
                          Container(
                              color:
                                  index1 == 1 ? Colors.white : Colors.grey[100],
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      width: 4,
                                      height: 40,
                                      color: index1 == 1
                                          ? Colors.red
                                          : Colors.grey[100],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 56,
                                    child: buildMenuItem(
                                        "FAVORITES".tr(),
                                        Colors.transparent,
                                        LineIcons.heartAlt, () {
                                      setState(() {
                                        index1 = 1;
                                        clickcol = index2 = index3 =
                                            index4 = index5 = index6 = 0;
                                      });
                                      Route route = MaterialPageRoute(
                                          builder: (context) => FavoriteList());
                                      push(context, route);
                                    }),
                                  )
                                ],
                              )),
                          Container(
                              color:
                                  index2 == 1 ? Colors.white : Colors.grey[100],
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      width: 4,
                                      height: 40,
                                      color: index2 == 1
                                          ? Colors.red
                                          : Colors.grey[100],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 56,
                                    child: buildMenuItem(
                                      "MY PROFILE".tr(),
                                      Colors.transparent,
                                      LineIcons.user,
                                      goToProfile,
                                    ),
                                  )
                                ],
                              )),
                          Container(
                              color:
                                  index3 == 1 ? Colors.white : Colors.grey[100],
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      width: 4,
                                      height: 40,
                                      color: index3 == 1
                                          ? Colors.red
                                          : Colors.grey[100],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 56,
                                    child: buildMenuItem("SETTINGS".tr(),
                                        Colors.transparent, LineIcons.cog, () {
                                      setState(() {
                                        index3 = 1;
                                        clickcol = index1 = index2 =
                                            index4 = index5 = index6 = 0;
                                      });
                                      Route route = MaterialPageRoute(
                                          builder: (context) => Settings());
                                      push(context, route);
                                    }),
                                  )
                                ],
                              )),
                          CustomPaint(
                            child: Container(
                                color: index4 == 1
                                    ? Colors.white
                                    : Colors.grey[100],
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        width: 4,
                                        height: 40,
                                        color: index4 == 1
                                            ? Colors.red
                                            : Colors.grey[100],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 56,
                                      child: buildMenuItem(
                                          "RATE APP".tr(),
                                          Colors.transparent,
                                          LineIcons.starHalfAlt,
                                          rateApp),
                                    )
                                  ],
                                )),
                          ),
                          Container(
                              color:
                                  index3 == 1 ? Colors.white : Colors.grey[100],
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      width: 4,
                                      height: 40,
                                      color: index3 == 1
                                          ? Colors.red
                                          : Colors.grey[100],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 56,
                                    child: buildMenuItem("SHOP".tr(),
                                        Colors.transparent, LineIcons.cog, () {
                                      setState(() {
                                        index7 = 1;
                                        clickcol = index1 = index2 =
                                            index4 = index5 = index6 = index3=0;
                                      });
                                      Route route = MaterialPageRoute(
                                          builder: (context) => Products());
                                      push(context, route);
                                    }),
                                  )
                                ],
                              )),
                          Container(
                              color:
                                  index6 == 1 ? Colors.white : Colors.grey[100],
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      width: 4,
                                      height: 40,
                                      color: index6 == 1
                                          ? Colors.red
                                          : Colors.grey[100],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 56,
                                    child: buildMenuItem(
                                        "LOG OUT".tr(),
                                        Colors.transparent,
                                        LineIcons.alternateSignOut,
                                        logout),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                    appBar: AppBar(
                      centerTitle: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      bottomOpacity: 0.0,
                      title: Row(
                        children: [
                          // GestureDetector(
                          //   child: Icon(Icons.sort, size: 30),
                          //   onTap: () {
                          //     setState(() {
                          //       openMenu = true;
                          //     });
                          //   },
                          // ),
                          SizedBox(width: 10),
                        ],
                      ),
                      actions: <Widget>[
                        // LiveWidget(),
                        buildProfileImage(context),
                        SizedBox(
                          width: 5,
                        ),
                        Stack(
                          children: [
                            Positioned(
                                child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  themeChange.darkTheme =
                                      !themeChange.darkTheme;
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  height: 28,
                                  width: 55,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .color,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Stack(
                                    children: [
                                      AnimatedPositioned(
                                          duration: Duration(milliseconds: 250),
                                          left:
                                              (themeChange.darkTheme) ? 1 : 28,
                                          top: 1,
                                          bottom: 1,
                                          child: Container(
                                            height: 26,
                                            width: 26,
                                            child: Icon(
                                              (themeChange.darkTheme)
                                                  ? Icons.wb_sunny
                                                  : Icons.nights_stay_rounded,
                                              size: 16,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            )),
                          ],
                        ),
                      ],
                    ),
                    body: PageView.builder(
                      onPageChanged: (page) {
                        setState(() {
                          Config.selectedIndex = page;
                        });
                      },
                      controller: controller,
                      itemBuilder: (context, position) {
                        return fragments[position];
                      },
                      itemCount: 5, // Can be null
                    ),
                  ),
                )
              ],
            ),
          ),
          AnimatedPositioned(
              top: (openMenu == true)
                  ? 0
                  : (-(MediaQuery.of(context).size.height)),
              child: Container(
                padding: EdgeInsets.only(left: 25, right: 25, top: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          buildProfileItem(),
                          buildMenuItem(
                              "HOME PAGE".tr(), Colors.blue, LineIcons.home,
                              () {
                            setState(() {
                              Config.selectedIndex = 0;
                              openMenu = false;
                            });
                            controller.jumpToPage(Config.selectedIndex);
                          }),
                          buildMenuItem(
                              "FAVORITES".tr(), Colors.lime, LineIcons.heartAlt,
                              () {
                            Route route = MaterialPageRoute(
                                builder: (context) => FavoriteList());
                            push(context, route);
                          }),
                          buildMenuItem("MY PROFILE".tr(), Colors.green,
                              LineIcons.user, goToProfile),
                          buildMenuItem("SETTINGS".tr(), Colors.indigoAccent,
                              LineIcons.cog, () {
                            Route route = MaterialPageRoute(
                                builder: (context) => Settings());
                            push(context, route);
                          }),
                          // buildMenuItem("Language".tr(), Colors.indigoAccent,
                          //     LineIcons.language, () {
                          //   showLanguageDialog();
                          // }),
                          /*  context.locale == Locale("en", "")
                              ? buildMenuItem("ARABIC".tr(), Colors.indigoAccent,
                                  LineIcons.language, () {
                                  context.setLocale(Locale("ar", ""));
                                })
                              : buildMenuItem("English".tr(),
                                  Colors.indigoAccent, LineIcons.language, () {
                                  context.setLocale(Locale("en", ""));
                                }),
                          context.locale == Locale("he", "")
                              ? buildMenuItem("English".tr(),
                                  Colors.indigoAccent, LineIcons.language, () {
                                  context.setLocale(Locale("en", ""));
                                })
                              : buildMenuItem("Hebrew".tr(),
                                  Colors.indigoAccent, LineIcons.language, () {
                                  context.setLocale(Locale("he", ""));
                                }),*/

                          buildMenuItem("RATE APP".tr(), Colors.orangeAccent,
                              LineIcons.starHalfAlt, rateApp),
                          buildMenuItem("LOG OUT".tr(), Colors.deepOrange,
                              LineIcons.alternateSignOut, logout),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Material(
                              color: Theme.of(context)
                                  .backgroundColor, // button color
                              child: InkWell(
                                splashColor: Colors.transparent, //
                                onTap: () {
                                  setState(() {
                                    openMenu = false;
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(LineIcons.angleUp,
                                          color: Theme.of(context).accentColor,
                                          size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              duration: Duration(milliseconds: 250)),
        ],
      ),
    );
  }

  buildMenuItem(String title, Color color, IconData icon, Function action) {
    bool hovcol = false;
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          //splashColor: Colors.white,
          hoverColor: Colors.white,
          onTap: action,
          onHover: (ishover) {
            if (ishover) {
              setState(() {
                hovcol = !hovcol;
              });
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Container(
                margin: EdgeInsets.all(8),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.redAccent),
              ),
              Expanded(
                  child: Text(
                title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )),
              // Icon(
              //   LineIcons.angleRight,
              //   size: 18,
              //   color: Colors.white,
              // ),
              // SizedBox(width: 10)
            ],
          ),
        ),
      ),
    );
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("ID_USER");
    prefs.remove("SALT_USER");
    prefs.remove("TOKEN_USER");
    prefs.remove("NAME_USER");
    prefs.remove("TYPE_USER");
    prefs.remove("USERNAME_USER");
    prefs.remove("IMAGE_USER");
    prefs.remove("EMAIL_USER");
    prefs.remove("DATE_USER");
    prefs.remove("GENDER_USER");
    prefs.remove("LOGGED_USER");

    Fluttertoast.showToast(
      msg: "You have logout in successfully !".tr(),
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    setState(() {
      getLogged();
      openMenu = false;
      index6 = 1;
      clickcol = index1 = index2 = index4 = index5 = index3 = 0;
    });
  }

  Future<String> getLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    logged = prefs.getBool("LOGGED_USER");

    if (logged == true) {
      image = Image.network(prefs.getString("IMAGE_USER"));
      name = prefs.getString("NAME_USER");
      email = prefs.getString("EMAIL_USER");
    } else {
      logged = false;
      image = Image.asset("assets/images/profile.jpg");
    }
  }

  @override
  void onReady() {
    setState(() {
      getLogged();
    });
  }

  @override
  void onResume() {
    setState(() {
      getLogged();
    });
  }

  buildProfileImage(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, top: 12, bottom: 12),
        child: GestureDetector(
          onTap: goToProfile,
          child: CircleAvatar(
            radius: 18,
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.blue, Colors.blue])),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipOval(
                    child: Container(
                      child: image,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  goToProfile() {
    openMenu = false;
    setState(() {
      index2 = 1;
      clickcol = index1 = index3 = index4 = index5 = index6 = 0;
    });
    if (logged != true) {
      push(
          context,
          PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return Login();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = Offset(0.0, 1.0);
                var end = Offset.zero;
                var tween = Tween(begin: begin, end: end);
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 300),
              opaque: false));
    } else {
      Route route = MaterialPageRoute(builder: (context) => Profile());
      push(context, route);
    }
  }

  buildProfileItem() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
              SizedBox(
                width: 130,
              ),
              Positioned(
                child: Center(
                  child: CoolDropdown(
                      dropdownList: Languages,
                      resultWidth: 70,
                      resultTS: TextStyle(
                        color: Colors.grey,
                      ),
                      resultHeight: 34,
                      dropdownHeight: 160,
                      isTriangle: false,
                      dropdownItemGap: 0,
                      gap: 0,
                      isAnimation: false,
                      placeholder: "Ar",
                      dropdownWidth: 70,
                      dropdownBD: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      resultIcon: Icon(Icons.language_outlined),
                      resultPadding: EdgeInsets.only(right: 4, left: 7),
                      resultIconRotation: false,
                      resultIconLeftGap: 0,
                      selectedItemBD: BoxDecoration(
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      resultBD: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      onChange: (value) {
                        print(value);
                        if (value == Languages[0]) {
                          context.setLocale(Locale("en", ""));
                        } else if (value == Languages[1]) {
                          context.setLocale(Locale("ar", ""));
                        } else if (value == Languages[2]) {
                          context.setLocale(Locale("he", ""));
                        }
                        setState(() {});
                      }),
                ),
              ),
              //Icon(Icons.question_answer_outlined),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: GestureDetector(
            onTap: goToProfile,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    // gradient: LinearGradient(
                    //     begin: Alignment.topRight,
                    //     end: Alignment.bottomLeft,
                    //     colors: [Colors.blue, Colors.blue])
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      child: image,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(name.tr(),
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.subtitle1.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      SizedBox(height: 3),
                      Text((email != null) ? email.tr() : name.toLowerCase(),
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.subtitle2.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 13))
                    ],
                  ),
                ),
                // Icon(
                //   LineIcons.angleRight,
                //   size: 18,
                //   color: Theme
                //       .of(context)
                //       .textTheme
                //       .subtitle1
                //       .color,
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future onSelectNotification(String payload) async {
    Map parsed = convert.json.decode(payload);
    if (parsed["type"] == "link") {
      _launchURL(parsed["data"]);
    } else if (parsed["type"] == "post") {
      Route route =
          MaterialPageRoute(builder: (context) => Splash(post: parsed["data"]));
      Navigator.pushReplacement(context, route);
    } else if (parsed["type"] == "status") {
      Route route = MaterialPageRoute(
          builder: (context) => Splash(status: parsed["data"]));
      Navigator.pushReplacement(context, route);
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;
    setState(() {
      index4 = 1;
      clickcol = index1 = index3 = index2 = index5 = index6 = 0;
    });

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  Future initAppInfos() async {
    var _applogo;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _applogo = prefs.getString("app_logo");
    return _applogo;
  }

  void showGDPR() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AdsProvider adsProvider = AdsProvider(prefs,
        (Platform.isAndroid) ? TargetPlatform.android : TargetPlatform.iOS);
    GdprDialog.instance
        .showDialog()
        //.showDialog(adsProvider.getAdmobPublisherId().toString(), apiConfig.api_url.replaceAll("/api/", "/privacy_policy.html"))
        .then((onValue) {});
  }

//   void showLanguageDialog() {
//     showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         String selectedLng = context.locale.languageCode;
//         return AlertDialog(
//           title: Text("Languages".tr(),style: TextStyle(color: Colors.black),),
//           content: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   InkWell(
//                     onTap: (){
//                       setState(() => selectedLng = "ar");
//                       context.setLocale(Locale("ar", ""));
//                       Navigator.of(context).pop();
//                       Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (BuildContext context) => super.widget));
//                     },
//                     child: Row(
//                       children: [
//                         Radio<String>(
//                           value: "en",
//                           activeColor: Colors.red,
//                           groupValue: selectedLng,
//                           onChanged: (String value) {
//                             setState(() => selectedLng = "en");
//                             context.setLocale(Locale("en", ""));
//                             Navigator.of(context).pop();
//                             Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (BuildContext context) => super.widget));
//                           },
//                         ),
//                         Text("English",style: TextStyle(color: Colors.black),)
//                       ],
//                     ),
//                   ),
//                   InkWell(
//                     onTap: (){
//                       setState(() => selectedLng = "ar");
//                       context.setLocale(Locale("ar", ""));
//                       Navigator.of(context).pop();
//                       Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (BuildContext context) => super.widget));
//                     },
//                     child: Row(
//                       children: [
//                         Radio<String>(
//                           value: "ar",
//                           activeColor: Colors.red,
//                           groupValue: selectedLng,
//                           onChanged: (String value) {
//                             setState(() => selectedLng = "ar");
//                             context.setLocale(Locale("ar", ""));
//                             Navigator.of(context).pop();
//                             Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (BuildContext context) => super.widget));
//                           },
//                         ),
//                         Text("Arabic",style: TextStyle(color: Colors.black),)
//                       ],
//                     ),
//                   ),
//                   InkWell(
//                     onTap: (){
//                       setState(() => selectedLng = "he");
//                       context.setLocale(Locale("he", ""));
//                       Navigator.of(context).pop();  Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (BuildContext context) => super.widget));
//                     },
//                     child: Row(
//                       children: [
//                         Radio<String>(
//                           value: "he",
//                           activeColor: Colors.red,
//                           groupValue: selectedLng,
//                           onChanged: (String value) {
//                             setState(() => selectedLng = "he");
//                             context.setLocale(Locale("he", ""));
//                             Navigator.of(context).pop();
//                             Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (BuildContext context) => super.widget));
//                           },
//                         ),
//                         Text("Hebrew",style: TextStyle(color: Colors.black),)
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
}
