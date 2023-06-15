
import 'dart:ui';


import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:myteam/api/api_rest.dart';
import 'package:myteam/config/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:myteam/screens/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //ArsProgressDialog progressDialog;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

  String tokenKey ="none";

  @override
  void initState() {
    // TODO: implement initState


    super.initState();
    getToken();



  }


  Future<String>  _register(String username,String email,String password,String image,String name,String type) async{
   /* progressDialog = ArsProgressDialog(
        context,
        blur: 5,
        dismissable: false,
        useSafeArea: true,
        backgroundColor: Color(0x33000000),
        loadingWidget: Container(
          decoration: BoxDecoration(
              color:  Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [BoxShadow(
                  color: Theme.of(context).primaryColor,
                  offset: Offset(0,0),
                  blurRadius: 1
              )]
          ),
          width: 150,
          height: 150,
          child: LoadingWidget(),
        ));

    progressDialog.show();*/
    var statusCode = 200;
    var response;
    var jsonData;
    try {
      response = await http.post(apiRest.registerUser(), body: {'username': username.tr(),'email':email.tr(), 'password': password.tr(),'name': name.tr(),"image":image.tr(),"type":type,"firebase":tokenKey});
      jsonData =  convert.jsonDecode(response.body);

    } catch (ex) {
      statusCode =  500;

    }

    if(statusCode == 200){
      if(jsonData["code"] == 200){
        int id_user=0;
        String name_user="x";
        String username_user="x";
        String email_user="";
        String gender_user="Gender";
        String date_user="1901-01-01";
        String salt_user="0";
        String token_user="0";
        String type_user="x";
        String image_user="x";
        bool enabled = false;

        for(Map i in jsonData["values"]){
            if(i["name"] == "id") {
              id_user = i["value"];
            }
            if(i["name"] == "name") {
              name_user = i["value"];
            }
            if(i["name"] == "username") {
              username_user =  i["value"];
            }
            if(i["name"] == "email") {
              email_user =  i["value"];
            }
            if(i["name"] == "url") {
              image_user  = i["value"] ;
            }
            if(i["name"] == "salt") {
              salt_user =  i["value"];
            }
            if(i["name"] == "token") {
              token_user = i["value"];
            }
            if(i["name"] == "type") {
              type_user = i["value"];
            }
            if(i["name"] == "date") {
              date_user = i["value"];
            }
            if(i["name"] == "gender") {
              gender_user = i["value"];
            }
            if(i["name"] == "enabled") {
              enabled = i["value"];
            }
        }

        if (enabled == true ) {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setInt("ID_USER", id_user);
          prefs.setString("SALT_USER", salt_user);
          prefs.setString("TOKEN_USER", token_user);
          prefs.setString("NAME_USER", name_user);
          prefs.setString("TYPE_USER", type_user);
          prefs.setString("USERNAME_USER", username_user);
          prefs.setString("IMAGE_USER", image_user);
          prefs.setString("EMAIL_USER", email_user);
          prefs.setString("DATE_USER", date_user);
          prefs.setString("GENDER_USER", gender_user);
          prefs.setBool("LOGGED_USER", true);
          Fluttertoast.showToast(
            msg: "You have logged in successfully !".tr(),
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Navigator.pop(context);
        }else{
          Fluttertoast.showToast(
            msg: "Operation has been cancelled !".tr(),
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }else{

        Fluttertoast.showToast(
          msg: "Operation has been cancelled !",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );

      }
    }else{
      Fluttertoast.showToast(
        msg: "Operation has been cancelled !".tr(),
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    //progressDialog.dismiss();

  }
  Future<UserCredential> signInWithGoogle() async {

    final FirebaseAuth _auth = FirebaseAuth.instance;

    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      _register(currentUser.uid, currentUser.email, currentUser.uid, currentUser.photoURL, currentUser.displayName, "google");
    }else{
      Fluttertoast.showToast(
        msg: "Operation has been cancelled !".tr(),
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  Future<void> _Facebooklogin() async {

      LoginResult loaginResult = await FacebookAuth.instance.login();
      AccessToken accessToken = loaginResult.accessToken;
      final userData = await FacebookAuth.instance.getUserData();

      _register(userData["id"],userData["email"], userData["id"], userData["picture"]["data"]["url"], userData["name"],"facebook");

  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onTap: () {
                    },
                    child:
                    Dismissible(
                      onDismissed: (direction){
                        Navigator.pop(context);
                      },

                      key: Key("item_1"),
                      direction: DismissDirection.down,
                      child: Container(
                        padding: EdgeInsets.only(left: 20,right: 20,bottom: 30,top: 0),
                          decoration: new BoxDecoration(
                              boxShadow: [BoxShadow(
                                  color: Colors.black87,
                                  offset: Offset(0,0),
                                  blurRadius: 5
                              )],
                              color: Theme.of(context).cardColor,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0),
                              )
                          ),
                        child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                 Navigator.pop(context);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 20),
                                  child: Container(
                                    height: 7,
                                    width: 70,
                                    decoration: new BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        borderRadius: new BorderRadius.circular(5)
                                    )
                                  ),
                                ),
                              )
                            ),
                            Text(
                                "Sign in for free!".tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Theme.of(context).textTheme.bodyText2.color
                                ),
                            ),
                            SizedBox(height: 25),
                            Text(
                              "In order to collect,like,follow,share, and download free content you have to signed up/in,Signing up/in is free and has a lot of advantages : ".tr(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).textTheme.bodyText2.color
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Container(height: 5,width: 5,color: Theme.of(context).textTheme.bodyText2.color,margin: EdgeInsets.all(5),),
                                Text(
                                  "Post your status and share it with club community".tr(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).textTheme.bodyText2.color
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Container(height: 5,width: 5,color: Theme.of(context).textTheme.bodyText2.color,margin: EdgeInsets.all(5),),
                                Text(
                                  "Give your option in comment section".tr(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).textTheme.bodyText2.color
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Container(height: 5,width: 5,color: Theme.of(context).textTheme.bodyText2.color,margin: EdgeInsets.all(5),),
                                Text(
                                  "Start earning by Publish / Share / Download Content ".tr(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).textTheme.bodyText2.color
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Container(height: 5,width: 5,color: Theme.of(context).textTheme.bodyText2.color,margin: EdgeInsets.all(5),),
                                Text(
                                  "Invite other people's by using your Reference code".tr(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).textTheme.bodyText2.color
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [BoxShadow(
                                      color: Colors.indigo,
                                      offset: Offset(0,0),
                                      blurRadius: 1
                                  )]
                              ),
                              child: ElevatedButton.icon(
                               // padding: EdgeInsets.zero,
                                onPressed: _Facebooklogin,
                                icon:Icon( LineIcons.facebook ,color: Colors.white),
                                label: Text(
                                  "Sign in with facebook account !".tr(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                            FutureBuilder(
                              future: _initialization,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(child: Text("hasError".tr()+snapshot.error.toString(),));
                                }
                              if (snapshot.connectionState == ConnectionState.done)
                                return Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 40,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [BoxShadow(
                                          color: Colors.red,
                                          offset: Offset(0,0),
                                          blurRadius: 1
                                      )]
                                  ),
                                  child: ElevatedButton.icon(
                                   // padding: EdgeInsets.zero,
                                    onPressed:signInWithGoogle,
                                    icon:Icon( LineIcons.googleLogo ,color: Colors.white),
                                    label: Text(
                                      "Sign in with google account !".tr(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                );
                                return Text("Loading",);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
          ),
        ),
    );
  }

  void getToken() {
    _messaging.getToken().then((token) {
      tokenKey = token;
    }).catchError((e) {
    });
  }
}
