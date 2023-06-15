import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';
import 'package:myteam/api/api_rest.dart';
import 'package:myteam/config/colors.dart';
import 'package:myteam/model/post.dart';
import 'package:myteam/model/team.dart';
import 'package:http/http.dart' as http;
import 'package:myteam/model/article.dart';
import 'dart:convert' as convert;

import 'package:myteam/screens/articles/article_widget.dart';
import 'package:myteam/screens/empty.dart';
import 'package:myteam/screens/loading.dart';
import 'package:myteam/screens/post/post_widget.dart';
import 'package:myteam/screens/tryagain.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteList extends StatefulWidget {



  @override
  _FavoriteListState createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  List<Post> favoritePostsList = [];

  @override
  void initState() {
    // TODO: implement initState
    refreshing = false;
    _getList();
    super.initState();

  }
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool loading =  false;
  String state =  "progress";
  bool refreshing =  true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Theme.of(context).textTheme.bodyText1.color),
          leading: new IconButton(
            icon: new Icon(LineIcons.angleLeft),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("My Favorite".tr(),style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
          elevation: 0.0
      ),
      body: buildHome(),
    );
  }

  Future<List<Article>>  _getList() async{
      setState(() {
        state =  "progress".tr();
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String  favoritePostsString=  await prefs.getString('post_favorires'.tr());

      if(favoritePostsString != null){
        favoritePostsList = Post.decode(favoritePostsString);
      }
      if(favoritePostsList == null){
        favoritePostsList= [];
      }
      print(favoritePostsList.length.toString());
      for(Post post in favoritePostsList){
          print(post.title);
      }

      setState(() {
      state =  "success".tr();
    });

  }
  Widget buildHome() {
    switch(state){
      case "success":
        return RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          key: refreshKey,
          onRefresh:_getList,
          child:
          (favoritePostsList.length > 0)?

          ListView.builder(
              itemCount: favoritePostsList.length,
              itemBuilder: (context, index) {
                return PostWidget(post:favoritePostsList[index],favorite:postFavorite);
              }
          ):EmptyWidget(context),
        );
        break;
      case "progress":
        return LoadingWidget();
        break;
      case "error":
        return TryAgainButton(action:(){
          refreshing = false;
          _getList();
        });
        break;
    }
  }
  postFavorite(Post post) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String  favoritePostsString=  await prefs.getString('post_favorires');

    if(favoritePostsString != null){
      favoritePostsList = Post.decode(favoritePostsString);
    }
    if(favoritePostsList == null){
      favoritePostsList= [];
    }


    Post favorited_post =  null;
    for(Post favorite_post in favoritePostsList){
      if(favorite_post.id == post.id){
        favorited_post = favorite_post;
      }
    }
    if(favorited_post == null){
      favoritePostsList.add(post);
      setState(() {
        post.favorite = true;
      });
    }else{
      favoritePostsList.remove(favorited_post);
      setState(() {
        post.favorite = false;
      });
    }

    String encodedData = Post.encode(favoritePostsList);
    prefs.setString('post_favorires'.tr(),encodedData);
  }

}
