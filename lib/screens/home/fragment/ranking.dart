
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myteam/api/api_rest.dart';
import 'package:myteam/model/table.dart' as model;

import 'package:http/http.dart' as http;
import 'package:myteam/model/competition.dart';
import 'package:myteam/screens/home/ranking_table_widget.dart';
import 'package:myteam/screens/home/title_home_widget.dart';
import 'package:myteam/screens/loading.dart';
import 'package:myteam/screens/matches/competitions_widget.dart';
import 'dart:convert' as convert;

import 'package:myteam/screens/tryagain.dart';

class Ranking extends StatefulWidget {
  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {


  List<Competition> competitionsList = [];
  List<model.Table> tablesList = [];
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool loading =  false;
  bool refreshing =  true;
  String state =  "progress".tr();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshing =  false;
    _getList();
    super.initState();
  }

  Widget buildHome() {
    switch(state){
      case "success":
        return RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          key: refreshKey,
          onRefresh:_getList,
          child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              if(index== 0){
                return TitleHomeWidget(title : "Ranking".tr());
              }else if(index == 1){
                return CompetitionsWidget(competitions : competitionsList,action : selectTables);
              }else{
                return  ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: tablesList.length,
                  itemBuilder: (context, jndex) {
                    return  RankingTable(table : tablesList[jndex]);
                  },
                );
              }
            },),
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
  @override
  Widget build(BuildContext context) {
    return  buildHome();
  }

  Future<List<Competition>>  _getList() async{
    if(loading)
      return null;

    competitionsList.clear();
    loading =  true;

    if(refreshing == false) {
      setState(() {
        state = "progress".tr();
      });
      refreshing =  true;
    }
    // Await the http get response, then decode the json-formatted response.
    var response;
    var statusCode = 200;
    try {
      response = await http.get(apiRest.competitionsTables());
    } catch (ex) {
      statusCode = 500;
    }
    if(!loading)
      return null;
    if (statusCode == 200) {
      if (response.statusCode == 200) {
        var jsonData =  convert.jsonDecode(response.body);
        bool first  = true;
        for(Map i in jsonData){
          Competition competition = Competition.fromJson(i);
          if(first == true){
            tablesList = competition.tables;
            competition.selected = true;
            first = false;
          }
          competitionsList.add(competition);

        }
        setState(() {
          state =  "success".tr();
        });
      } else {
        setState(() {
          state =  "error".tr();
        });
      }
    }else if(statusCode == 500){
      setState(() {
        state =  "error".tr();
      });
    }
    loading = false;
  }

  selectTables(Competition competition) {
   setState(() {
     for(Competition c in competitionsList)
       c.selected=false;
     competition.selected=true;
     tablesList =  competition.tables;

   });
  }
}
