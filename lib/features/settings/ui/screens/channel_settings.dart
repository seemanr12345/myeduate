import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:myeduate/common/base/size_config.dart';
import 'package:myeduate/features/files/ui/screens/files.dart';

enum NotificationOption{message,channel,mute}

class ChannelSettings extends StatefulWidget {
  const ChannelSettings({Key? key, required this.token, required this.channelID, required this.channelName, required this.channelDesc, required this.channelTopic}) : super(key: key);
  final String token;
  final String channelID;
  final String channelName;
  final String channelDesc;
  final String? channelTopic;

  @override
  _ChannelSettingsState createState() => _ChannelSettingsState();
}

class _ChannelSettingsState extends State<ChannelSettings> {
  String channelStudentsListQuery="""
  query GetStudentsQuery(\$token:String!,\$msg_channel_id:ID!){
    GetStudentsByChannelId(token:\$token,msg_channel_id:\$msg_channel_id)
    {
      first_name
      last_name
    }
  }
  """;

  String channelParentsListQuery="""
  query GetParentsQuery(\$token:String!,\$msg_channel_id:ID!){
    GetParentsByChannelId(token:\$token,msg_channel_id:\$msg_channel_id)
    {
      first_name
    }
  }
  """;

  String channelEduateUsersListQuery="""
  query GetEduateUsersQuery(\$token:String!,\$msg_channel_id:ID!){
    GetEduateUsersByChannelId(token:\$token,msg_channel_id:\$msg_channel_id)
    {
      first_name
    }
  }
  """;

  List<String> ids=[];
  List<String> lastname=[];
  List<String> parentIds=[];
  List<String> eduateUserIds=[];
  NotificationOption? _option=NotificationOption.message;
  //List<String> participants=['Suresh','Sunil','Padma','Praveen','Akshaya B Jain','Sunil','Praveen','Padma','Akshaya B Jain','Padma',];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: _buildContent(),
      backgroundColor: Color(0xffFCFEFF),
      appBar: AppBar(
        backgroundColor: Color(0xffFCFEFF),
        leading: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(Icons.close, color: Color(0xff1A1B1C),)),
        title: Text('Channel Details',
        style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 24.0*SizeConfig.screenHeight/812.0,
          color: Color(0xff1A1B1C)
        )),
        ),
      ),
    );
  }

  Widget _buildContent() {
    double height=SizeConfig.screenHeight/812.0;
    double width=SizeConfig.screenWidth/375.0;
    return Padding(padding: EdgeInsets.only(top: 15.0*height, left: 14.0*width, right: 14.0*width, bottom: 19.77*height),
    child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 21.74*height, left: 12.42*width, right: 16.4*width, bottom: 15.28*height),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0*height),),
              boxShadow: [ BoxShadow(
                 color: const Color(0xFF000000).withOpacity(0.1),
                 blurRadius: 6.0,
              )],
              color: Color(0xffFDFCFF),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      margin:EdgeInsets.only(right: 18.0*width),
                      padding: EdgeInsets.only(top: 7.49*height, left: 10.7*width, right: 6.89*width, bottom: 10.1*height),
                      decoration: BoxDecoration(
                        color: Color(0xffE7E7E7),
                        borderRadius: BorderRadius.all(Radius.circular(10.42*height))
                      ),
                      child: Icon(Icons.add_photo_alternate_outlined, color: Color(0xff1A1B1C),size: 27.36*height,),
                    ),
                    Text(widget.channelName,
                    style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
fontSize: 18.0*height,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1A1B1C),
                    )),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 18.92*height, bottom: 10.0*height),
                    child: Text(
                      'Description',
                      style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
                        fontSize: 18.0*height,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1A1B1C),
                      )),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.channelDesc,
                  style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                    fontSize: 12.0*height,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1A1B1C),
                  )),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 6.0*height, bottom: 13.0*height),
                    child: Text(
                      'Sunil created this channel on 20th Jan 2022',
                      style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                        fontSize: 10.0*height,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff000000).withOpacity(0.45),
                      )),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.0*height),
                    child: Text(
                      'Topic',
                      style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
                        fontSize: 18.0*height,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1A1B1C),
                      )),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text((widget.channelTopic==null || widget.channelTopic=="")? "No topic set" : widget.channelTopic!,
                  style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0*height,
                    color: Color(0xff1A1B1C),
                  )),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: ((context) => Files(token: widget.token,channelID: widget.channelID,))));
            },
            child: Container(
              margin: EdgeInsets.only(top: 14.29*height, bottom: 18.26*height),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xff89D5FF), width: 0.5*height),
                  bottom: BorderSide(color: Color(0xff89D5FF), width: 0.5*height),
                ),
              ),
              padding: EdgeInsets.only(left: 2.67*width,top: 20.06*height, bottom: 20.69*height, right: 6.16*width),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.folder_outlined, color: Color(0xff1A1B1C), size: 26.67*width,),
                      Padding(
                        padding: EdgeInsets.only(left:13.03*width),
                        child: Text(
                          'Files',
                          style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
                            color: Color(0xff1A1B1C),
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0*height,
                          )),
                        ),
                      )
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, color: Color(0xff1264C3),size: 20.45*height,)
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.75*width, right: 16.01*width),
                    child: Icon(
                      Icons.notifications_none_outlined,
                      color: Color(0xff1A1B1C),
                      size: 26.0*height,
                    ),
                  ),
                  Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
                      color: Color(0xff1A1B1C),
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0*height,
                    )),
                  ),
                ],
              ),
              Text(_option==NotificationOption.message ?
                'Every new message' : _option==NotificationOption.channel ? 'Only from channels' : 'Mute notifications',
                style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0*height,
                  color: Color(0xff000000).withOpacity(0.45),
                )),
              ),
            ],
          ),
          SizedBox(
            height: 35.0*height,
            child: ListTile(
              title: Text('Notify every new message',
                style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                  color: Color(0xff1A1B1C),
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0*height,
                )),
              ),
              leading: Radio<NotificationOption>(
                value: NotificationOption.message,
                groupValue: _option,
                onChanged: (NotificationOption? value) {
                  setState(() {
                    _option = value;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: 35.0*height,
            child: ListTile(
              title:Text('Notify only from channels',
                style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                color: Color(0xff1A1B1C),
                fontWeight: FontWeight.w400,
                fontSize: 14.0*height,
              )),
            ),
              leading: Radio<NotificationOption>(
                value: NotificationOption.channel,
                groupValue: _option,
                onChanged: (NotificationOption? value) {
                  setState(() {
                    _option = value;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: 35.0*height,
            child: ListTile(
              title: Text('Mute Notifications',
                style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                  color: Color(0xff1A1B1C),
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0*height,
                )),
              ),
              leading: Radio<NotificationOption>(
                value: NotificationOption.mute,
                groupValue: _option,
                onChanged: (NotificationOption? value) {
                  setState(() {
                    _option = value;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 32.19*height),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'These settings apply only for your mobile, not on desktop.',
                style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                  fontSize: 10.0*height,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000).withOpacity(0.45),
                )),
              ),
            ),
          ),
          Query(
            options: QueryOptions(
                document: gql(channelStudentsListQuery),variables: {
              "token":widget.token,
              "msg_channel_id":widget.channelID
            }
            ),
            builder:(QueryResult studentLists, { VoidCallback? refetch, FetchMore? fetchMore }){
              if(studentLists.data==null)
              {
                print(studentLists);
                return Container();
              }
              ids=[];
              lastname=[];
              for(var i in studentLists.data!["GetStudentsByChannelId"])
              {
                ids.add(i["first_name"]);
                lastname.add(i["last_name"]);
              }
              return Container(
                margin: EdgeInsets.only(top: 15.01*height,
                   // bottom: 19.29*height
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xff89D5FF), width: 0.5*height),
                    bottom: BorderSide(color: Color(0xff89D5FF), width: 0.5*height),
                  ),
                ),
                padding: EdgeInsets.only(left: 1.33*width,top: 20.54*height, bottom: 15.23*height, right: 2*width),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.people_alt_outlined, color: Color(0xff1A1B1C), size: 29.33*width,),
                            Padding(
                              padding: EdgeInsets.only(left:13.03*width),
                              child: Text(
                                '${ids.length} Students',
                                style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
                                  color: Color(0xff1A1B1C),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0*height,
                                )),
                              ),
                            )
                          ],
                        ),
                        Icon(Icons.person_search_outlined, color: Color(0xff1264C3),size: 20.0*height,)
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0*height,),
                      padding: EdgeInsets.only(bottom: 6.19*height),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0*height),),
                        boxShadow: [ BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.1),
                          blurRadius: 6.0,
                        )],
                        color: Color(0xffFDFCFF),
                      ),

                      child: ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: ids.length,
                          itemBuilder: (BuildContext context, int index){
                            return SizedBox(
                              height: 50.0*height,
                              child: ListTile(
                                leading: Stack(
                                  children: [
                                    Positioned(
                                      child: Container(
                                        padding: EdgeInsets.all(9.25*height),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffE7E7E7)
                                        ),
                                        child: Icon(Icons.person_outline, size: 16.0*height,color: Color(0xff1a1b1c)),
                                      ),
                                    ),
                                  ],
                                ),
                                title: Text(ids[index]+" "+lastname[index],
                                  style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                                    color: Color(0xff1A1B1C),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0*height,
                                  )),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(top: 5.0*height),
                              child: Divider(height: 0,),
                            );
                          }
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          // Query(
          //   options: QueryOptions(
          //       document: gql(channelParentsListQuery),variables: {
          //     "token":widget.token,
          //     "msg_channel_id":widget.channelID
          //   }
          //   ),
          //   builder:(QueryResult parentLists, { VoidCallback? refetch, FetchMore? fetchMore }){
          //     if(parentLists.data==null)
          //     {
          //       print(parentLists);
          //       return Container();
          //     }
          //     parentIds=[];
          //     for(var i in parentLists.data!["GetParentsByChannelId"])
          //     {
          //       parentIds.add(i["first_name"]);
          //     }
          //     return Container(
          //       margin: EdgeInsets.only(top: 15.01*height,
          //          // bottom: 19.29*height
          //       ),
          //       decoration: BoxDecoration(
          //         border: Border(
          //           top: BorderSide(color: Color(0xff89D5FF), width: 0.5*height),
          //           bottom: BorderSide(color: Color(0xff89D5FF), width: 0.5*height),
          //         ),
          //       ),
          //       padding: EdgeInsets.only(left: 1.33*width,top: 20.54*height, bottom: 15.23*height, right: 2*width),
          //       child: Column(
          //         children: <Widget>[
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: <Widget>[
          //               Row(
          //                 children: <Widget>[
          //                   Icon(Icons.people_alt_outlined, color: Color(0xff1A1B1C), size: 29.33*width,),
          //                   Padding(
          //                     padding: EdgeInsets.only(left:13.03*width),
          //                     child: Text(
          //                       '${parentIds.length} Parents',
          //                       style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
          //                         color: Color(0xff1A1B1C),
          //                         fontWeight: FontWeight.w500,
          //                         fontSize: 20.0*height,
          //                       )),
          //                     ),
          //                   )
          //                 ],
          //               ),
          //               Icon(Icons.person_search_outlined, color: Color(0xff1264C3),size: 20.0*height,)
          //             ],
          //           ),
          //           Container(
          //             margin: EdgeInsets.only(top: 12.0*height,),
          //             padding: EdgeInsets.only(bottom: 8.19*height),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(Radius.circular(8.0*height),),
          //               boxShadow: [ BoxShadow(
          //                 color: const Color(0xFF000000).withOpacity(0.1),
          //                 blurRadius: 6.0,
          //               )],
          //               color: Color(0xffFDFCFF),
          //             ),
          //
          //             child: ListView.separated(
          //                 physics: NeverScrollableScrollPhysics(),
          //                 shrinkWrap: true,
          //                 itemCount: parentIds.length,
          //                 itemBuilder: (BuildContext context, int index){
          //                   return SizedBox(
          //                     height: 50.0*height,
          //                     child: ListTile(
          //                       leading: Stack(
          //                         children: [
          //                           Positioned(
          //                             child: Container(
          //                               padding: EdgeInsets.all(9.25*height),
          //                               decoration: BoxDecoration(
          //                                   shape: BoxShape.circle,
          //                                   color: Color(0xffE7E7E7)
          //                               ),
          //                               child: Icon(Icons.person_outline, size: 16.0*height,color: Color(0xff1a1b1c)),
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                       title: Text(parentIds[index],
          //                         style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
          //                           color: Color(0xff1A1B1C),
          //                           fontWeight: FontWeight.w500,
          //                           fontSize: 14.0*height,
          //                         )),
          //                       ),
          //                     ),
          //                   );
          //                 },
          //                 separatorBuilder: (context, index) {
          //                   return Padding(
          //                     padding: EdgeInsets.only(top: 18.0*height),
          //                     child: Divider(height: 0,),
          //                   );
          //                 }
          //             ),
          //           )
          //         ],
          //       ),
          //     );
          //   },
          // ),
          // Query(
          //   options: QueryOptions(
          //       document: gql(channelEduateUsersListQuery),variables: {
          //     "token":widget.token,
          //     "msg_channel_id":widget.channelID
          //   }
          //   ),
          //   builder:(QueryResult eduateUserLists, { VoidCallback? refetch, FetchMore? fetchMore }){
          //     if(eduateUserLists.data==null)
          //     {
          //       print(eduateUserLists);
          //       return Container();
          //     }
          //     eduateUserIds=[];
          //     for(var i in eduateUserLists.data!["GetEduateUsersByChannelId"])
          //     {
          //       eduateUserIds.add(i["first_name"]);
          //     }
          //     return Container(
          //       margin: EdgeInsets.only(top: 15.01*height, bottom: 19.29*height),
          //       decoration: BoxDecoration(
          //         border: Border(
          //           top: BorderSide(color: Color(0xff89D5FF), width: 0.5*height),
          //           bottom: BorderSide(color: Color(0xff89D5FF), width: 0.5*height),
          //         ),
          //       ),
          //       padding: EdgeInsets.only(left: 1.33*width,top: 20.54*height, bottom: 15.23*height, right: 2*width),
          //       child: Column(
          //         children: <Widget>[
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: <Widget>[
          //               Row(
          //                 children: <Widget>[
          //                   Icon(Icons.people_alt_outlined, color: Color(0xff1A1B1C), size: 29.33*width,),
          //                   Padding(
          //                     padding: EdgeInsets.only(left:13.03*width),
          //                     child: Text(
          //                       '${eduateUserIds.length} Eduate Users',
          //                       style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
          //                         color: Color(0xff1A1B1C),
          //                         fontWeight: FontWeight.w500,
          //                         fontSize: 20.0*height,
          //                       )),
          //                     ),
          //                   )
          //                 ],
          //               ),
          //               Icon(Icons.person_search_outlined, color: Color(0xff1264C3),size: 20.0*height,)
          //             ],
          //           ),
          //           Container(
          //             margin: EdgeInsets.only(top: 12.0*height,),
          //             padding: EdgeInsets.only(bottom: 8.19*height),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(Radius.circular(8.0*height),),
          //               boxShadow: [ BoxShadow(
          //                 color: const Color(0xFF000000).withOpacity(0.1),
          //                 blurRadius: 6.0,
          //               )],
          //               color: Color(0xffFDFCFF),
          //             ),
          //
          //             child: ListView.separated(
          //                 physics: NeverScrollableScrollPhysics(),
          //                 shrinkWrap: true,
          //                 itemCount: eduateUserIds.length,
          //                 itemBuilder: (BuildContext context, int index){
          //                   return SizedBox(
          //                     height: 50.0*height,
          //                     child: ListTile(
          //                       leading: Stack(
          //                         children: [
          //                           Positioned(
          //                             child: Container(
          //                               padding: EdgeInsets.all(9.25*height),
          //                               decoration: BoxDecoration(
          //                                   shape: BoxShape.circle,
          //                                   color: Color(0xffE7E7E7)
          //                               ),
          //                               child: Icon(Icons.person_outline, size: 16.0*height,color: Color(0xff1a1b1c)),
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                       title: Text(eduateUserIds[index],
          //                         style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
          //                           color: Color(0xff1A1B1C),
          //                           fontWeight: FontWeight.w500,
          //                           fontSize: 14.0*height,
          //                         )),
          //                       ),
          //                     ),
          //                   );
          //                 },
          //                 separatorBuilder: (context, index) {
          //                   return Padding(
          //                     padding: EdgeInsets.only(top: 18.0*height),
          //                     child: Divider(height: 0,),
          //                   );
          //                 }
          //             ),
          //           )
          //         ],
          //       ),
          //     );
          //   },
          // ),
        /*  Row(
            children: <Widget>[
              Icon(Icons.format_list_bulleted_outlined, color: Color(0xff1A1B1C), size: 29.33*width,),
              Padding(
                padding: EdgeInsets.only(left:10.57*width),
                child: Text(
                  'Applications (0)',
                  style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
                    color: Color(0xff1A1B1C),
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0*height,
                  )),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 18.09*height,),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xff89D5FF), width: 0.5*height),
                bottom: BorderSide(color: Color(0xff89D5FF), width: 0.5*height),
              ),
            ),
            padding: EdgeInsets.only(left: 2.67*width,top: 20.06*height, bottom: 20.69*height, right: 6.16*width),
            child: Row(
              children: <Widget>[
                Icon(Icons.delete_outline_outlined, color: Color(0xff1A1B1C), size: 26.67*width,),
                Padding(
                  padding: EdgeInsets.only(left:13.03*width),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Unlist Channel',
                          style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
                            color: Color(0xff1A1B1C),
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0*height,
                          )),
                        ),
                      ),
                      Text(
                        'This action will remove this Channel from the Channel List.',
                        style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                          fontSize: 10.0*height,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff000000).withOpacity(0.45),
                        )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),*/
        ],
      ),
    ),
    );
  }
}
