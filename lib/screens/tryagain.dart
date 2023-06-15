import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:myteam/config/colors.dart';
class TryAgainButton extends StatelessWidget {
  Function action;

  TryAgainButton({ this.action});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
           // color: Theme.of(context).accentColor,
            onPressed: action,
            icon: Icon(LineIcons.syncIcon,color: Colors.white,),
            label: Text(
              "Try Again".tr(),
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        ],
      ),
    );
  }
}

