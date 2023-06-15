
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:myteam/api/api_rest.dart';
import 'package:myteam/config/colors.dart';
import 'package:myteam/model/team.dart';
import 'package:myteam/model/trophy.dart';
import 'package:myteam/screens/loading.dart';
import 'package:myteam/screens/trophies/trophy_widget.dart';
import 'package:myteam/screens/tryagain.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;



class TrophiesList extends StatefulWidget {

  Team team;


  TrophiesList({this.team});

  @override
  _TrophiesListState createState() => _TrophiesListState();
}

class _TrophiesListState extends State<TrophiesList> {



  @override
  void initState() {
    // TODO: implement initState
    refreshing = false;
    _getList();
    super.initState();

  }
  List<Trophy> trophiesList = [];
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
          title: Text(widget.team.title,style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
          elevation: 0.0
      ),
      body: buildHome(),
    );
  }

  Future<List<Trophy>>  _getList() async{
    if(loading)
      return null;
    trophiesList.clear();
    loading =  true;

    if(refreshing ==  false){
      setState(() {
        state =  "progress";
      });
      refreshing = true;
    }

    var response;
    try {
      response = await http.get(apiRest.getTrophiesByTeam(widget.team.id));
    } catch (ex) {
      loading = false;
      setState(() {
        state =  "error";
      });
    }
    if(!loading)
      return null;

    if (response.statusCode == 200) {
      var data  = await http.get(apiRest.getTrophiesByTeam(widget.team.id));
      var jsonData =  convert.jsonDecode(data.body);
      for(Map i in jsonData){
        Trophy position = Trophy.fromJson(i);
        trophiesList.add(position);
      }
      setState(() {
        state =  "success";
      });
    } else {
      setState(() {
        state =  "error";
      });
    }
    loading = false;
    return trophiesList;
  }
  Widget buildHome() {
    switch(state){
      case "success":
        return RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          key: refreshKey,
          onRefresh:_getList,
          child: ListView.builder(
              itemCount: trophiesList.length,
              itemBuilder: (context, index) {
                return TrophyWidget(trophy:trophiesList[index]);
              }
          ),
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
}
