import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:myteam/config/colors.dart';
import 'package:myteam/model/comment.dart';

class CommentWidget extends StatelessWidget {
  Comment comment ;

  CommentWidget({this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ClipOval(
                child: Container(
                  child: CachedNetworkImage(
                    imageUrl: comment.userimage,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    height: 30,
                    width: 30,
                  ),
                ),
              )
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(
                      color: Theme.of(context).cardColor,
                      offset: Offset(0,0),
                      blurRadius: 1
                  )]
              ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Button send image
                      // Edit text
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            comment.username,
                            style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 15,fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Container(
                        child: Icon(
                          LineIcons.clockAlt,
                          color: Theme.of(context).textTheme.bodyText2.color,
                          size: 15,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 5,left: 5),
                        child: Text(
                          comment.created,
                          style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: 11),
                        ),
                      ),
                      // Button send message
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      (comment.enabled == true)? comment.clear : "Comment has been hidden !",
                      style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color.withOpacity((comment.enabled == true)? 1:0.2), fontSize: 12),
                    ),

                  )
                ],
              ),
            ),
          )
        ],
      ),
      margin: const EdgeInsets.all(7),

    );
  }
}
