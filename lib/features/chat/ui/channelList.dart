import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import 'package:myeduate/features/chat/resource/chatQueries.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../dashboard/dashboard_ui.dart' as NavigationDrawer;
import '../../dashboard/dashboard_ui.dart';
import 'chatScreen.dart';
import 'package:myeduate/features/search/UI/screens/searchScreen.dart';

class ChannelList extends StatefulWidget {
  const ChannelList({
    Key? key,
    required this.token,
    required this.id,
    required this.userType,
    this.parentStudnetid,
  }) : super(key: key);
  final String? token;
  final dynamic id;
  final dynamic userType;
  final dynamic parentStudnetid;
  static void cacheData(Map<String, String> msgCountList) async {
    //Mutation to update readCountValue
  }

  @override
  _ChannelListState createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  bool channel = true;
  List ids = [];
  List<dynamic> reads = [];
  List<dynamic> count = [];
  var queries = Queries();
  String parentChannelListQuery = """""";
  String staffChannelListQuery = """""";
  String eduateChannelListQuery = """""";
  Map<String, int> fileCount = {};
  var msgs = [];
  String filter = '';
  TextEditingController _searchEditingController = TextEditingController();
  final preferences = SharedPreferences.getInstance();
  Map<String, String> unreadCountList = {};
  Map<String, String> msg_count_display = {};
  int _selectedState = 0;
  @override
  void initState() {
    super.initState();
    // msg_count_display = {};
    // displayUnreadCount;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedState = index;
      if (_selectedState == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => DashBoard())));
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const NavigationDrawer.NavigationDrawer(),
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 1,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/images/myeduate_logo.svg',
              height: 20,
              width: 30,
            ),
            const SizedBox(
              width: 5,
            ),
            Text("Eduate",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 18))
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.notifications_none),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  // print(widget.parentStudnetid);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => SearchScreen(
                  //             id: widget.parentStudnetid == null
                  //                 ? widget.id.toString()
                  //                 : widget.parentStudnetid.toString(),
                  //             tokenn: widget.token,
                  //           )),
                  // );
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.blue,
                ),
              ),
              const SizedBox(width: 15)
            ],
          )
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem> [
      //   // BottomNavigationBarItem(label: 'Messages',icon: Icon(Icons.message,),  ),
      //   BottomNavigationBarItem(label: 'Channels',icon: Icon(Icons.list),),
      //   BottomNavigationBarItem(label: 'Dashboard',icon: SvgPicture.asset('assets/images/SquaresFour.svg'))
      // ],
      //   type: BottomNavigationBarType.shifting,
      //   selectedItemColor: Colors.blue,
      //   unselectedItemColor: Color(0xff90979F),
      //   showUnselectedLabels: true,
      //   currentIndex: _selectedState,
      //   onTap: _onItemTapped,
      //   ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Card(
      //   elevation: 5,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.end,
      //     children: [
      //       SizedBox(
      //           height: height * .075,
      //           width: width / 3.1,
      //           child: const Icon(Icons.list)),
      //       GestureDetector(
      //           onTap: () {
      //             print(widget.parentStudnetid);
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) => SearchScreen(
      //                         id: widget.parentStudnetid == null
      //                             ? widget.id.toString()
      //                             : widget.parentStudnetid.toString(),
      //                         tokenn: widget.token,
      //                       )),
      //             );
      //           },
      //           child: Container(
      //               width: width / 3.1,
      //               height: height * 0.075,
      //               child: const Icon(Icons.search))),
      //       SizedBox(
      //           width: width / 3.1,
      //           height: height * .075,
      //           child: const Icon(Icons.dashboard)),
      //     ],
      //   ),
      // ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              width: width,
              height: height / 20,
              // decoration: const BoxDecoration(
              //     borderRadius: BorderRadius.all(Radius.circular(40)),
              //     color: Color(0xffE7E7E7)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Channels",
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: !channel ? Colors.white : Colors.black),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     setState(() {
                  //       channel = true;
                  //     });
                  //   },
                  //   child: Container(
                  //     width: width * .36,
                  //     height: height / 13.5,
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.all(Radius.circular(30)),
                  //         color: channel
                  //             ? const Color(0xff1264C3)
                  //             : const Color(0xffE7E7E7)),
                  //     child: Center(
                  //       child: Text(
                  //         "Channels",
                  //         style: Theme.of(context)
                  //             .textTheme
                  //             .bodyText1
                  //             ?.copyWith(
                  //                 fontSize: 18,
                  //                 fontWeight: FontWeight.w600,
                  //                 color: channel ? Colors.white : Colors.black),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // GestureDetector(
                  //   onTap: () async {
                  //     var x =
                  //         await FirebaseAuth.instance.currentUser!.getIdToken();
                  //     print(x);
                  //     setState(() {
                  //       channel = false;
                  //     });
                  //   },
                  //   child: Container(
                  //     width: width * .36,
                  //     height: height / 13.5,
                  //     decoration: BoxDecoration(
                  //         borderRadius:
                  //             const BorderRadius.all(Radius.circular(30)),
                  //         color: !channel
                  //             ? const Color(0xff1264C3)
                  //             : const Color(0xffE7E7E7)),
                  //     child: Center(
                  //       child: Text(
                  //         "Messages",
                  //         style: Theme.of(context)
                  //             .textTheme
                  //             .bodyText1
                  //             ?.copyWith(
                  //                 fontSize: 18,
                  //                 fontWeight: FontWeight.w600,
                  //                 color:
                  //                     !channel ? Colors.white : Colors.black),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            SizedBox(height: height * .02),
            Query(
                options: QueryOptions(
                    document: gql(queries.studentChannelListQuery),
                    variables: {
                      "token": widget.token,
                      "student_id": widget.parentStudnetid ?? widget.id,
                    },
                    pollInterval: const Duration(seconds: 30),
                    fetchPolicy: FetchPolicy.cacheAndNetwork),
                builder: (QueryResult channelResult,
                    {VoidCallback? refetch, FetchMore? fetchMore}) {
                  if (channelResult.data == null) {
                    print(channelResult);
                    return Container();
                  }
                  ids = [];
                  for (var i in channelResult
                      .data!["GetChannelSubscribedByStudentId"]) {
                    ids.add(i["msg_channel_id"]);
                  }
                  print("Hello $channelResult");
                  return Query(
                      options: QueryOptions(
                          document: gql(queries.getReadCountQuery),
                          variables: {
                            "token": widget.token,
                            "msg_channel_ids": ids,
                            "student_id": widget.parentStudnetid == null
                                ? widget.id
                                : widget.parentStudnetid,
                          },
                          pollInterval: const Duration(seconds: 5),
                          fetchPolicy: FetchPolicy.cacheAndNetwork),
                      builder: (QueryResult readResult,
                          {VoidCallback? refetch, FetchMore? fetchMore}) {
                        if (readResult.data == null) {
                          return Center(
                              child:
                                  Container(child: Text('No Channels Found')));
                        }

                        reads = [];
                        for (var i in readResult
                            .data!["GetChannelReadCountByStudentId"]) {
                          unreadCountList[i["msg_channel_id"].toString()] =
                              i["msg_read_count"].toString();
                          print('READ RESULT: $readResult');
                        }

                        return Column(
                          children: [
                            Container(
                                padding: EdgeInsets.all(width * .019),
                                height: height / 20,
                                width: width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xffF3F5F8),
                                ),
                                child: TextFormField(
                                  onChanged: (value) {
                                    print('Inside Form Field $value');
                                    filter = value;
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Jump to",
                                      fillColor: Color(0xffF3F5F8),
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          ?.copyWith(
                                              color: const Color(0xffA4A4A6),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      suffixIcon: const Icon(Icons.search)),
                                )),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: width * 0.00,
                                  ),
                                  Icon(
                                    Icons.delete,
                                    color: Color(0xff676E76),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Text('Unlisted Channels',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                            Container(
                              height: height * 0.02,
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color(0xffDBDDDF), width: 1)),
                              ),
                            ),
                            (_selectedState == 0)
                                ? SizedBox(
                                    height: height / 2,
                                    width: width,
                                    child: ListView(
                                      children: [
                                        Query(
                                            options: QueryOptions(
                                                document:
                                                    gql(queries.nodeQuery),
                                                variables: {
                                                  "token": widget.token,
                                                  "ids": ids
                                                }),
                                            builder: (QueryResult channelLists,
                                                {VoidCallback? refetch,
                                                FetchMore? fetchMore}) {
                                              print(channelResult.data);
                                              if (channelLists.data == null) {
                                                print(channelLists);
                                                return const Text(
                                                    "No channels Found");
                                              }
                                              channelLists.data!["nodes"];
                                              print('Here 123 ${channelLists}');

                                              int count123 = 0;
                                              List dummy_list = [];
                                              for (int i = 0;
                                                  i <
                                                      channelLists
                                                          .data!["nodes"]
                                                          .length;
                                                  i++) {
                                                if (channelLists.data!["nodes"]
                                                            [i]["channel_name"]
                                                        .toLowerCase()
                                                        .contains(filter
                                                            .toLowerCase()) &&
                                                    filter != '') {
                                                  count123++;

                                                  dummy_list.add(i);
                                                  print(
                                                      "$dummy_list $count123");
                                                }
                                              }

                                              return Wrap(
                                                children: List.generate(
                                                    // channelLists
                                                    //     .data!["nodes"].length,
                                                    // (dummy_list.isEmpty &&
                                                    //         filter.isEmpty)
                                                    //     ?
                                                    channelLists
                                                        .data!["nodes"].length,
                                                    // : count123,
                                                    (index) => Container(
                                                          width: width,
                                                          height: 70,
                                                          decoration:
                                                              const BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    color: Color(
                                                                        0xffDBDDDF),
                                                                    width: 1)),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  flex: 2,
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.fromLTRB(
                                                                        0,
                                                                        width *
                                                                            .02,
                                                                        width *
                                                                            0.02,
                                                                        width *
                                                                            0.02),
                                                                    child: Container(
                                                                        decoration: const BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(8)),
                                                                          color:
                                                                              Color(0xffFFDB05),
                                                                        ),
                                                                        child: const Center(
                                                                          child:
                                                                              Icon(Icons.photo),
                                                                        )),
                                                                  )),
                                                              Expanded(
                                                                  flex: 8,
                                                                  child: Query(
                                                                      options:
                                                                          QueryOptions(
                                                                        document:
                                                                            gql(queries.messagesQuery),
                                                                        variables: {
                                                                          "token":
                                                                              widget.token,
                                                                          "msg_channel_id":
                                                                              ids[index].toString(),
                                                                          "searchString":
                                                                              filter
                                                                        },
                                                                        fetchPolicy:
                                                                            FetchPolicy.cacheAndNetwork,
                                                                        pollInterval:
                                                                            const Duration(seconds: 1),
                                                                      ),
                                                                      builder: (QueryResult
                                                                              channelResult,
                                                                          {VoidCallback?
                                                                              refetch,
                                                                          FetchMore?
                                                                              fetchMore}) {
                                                                        if (channelResult
                                                                            .isLoading) {
                                                                          return Container();
                                                                        }
                                                                        // log("Hello1234 ${channelResult.data!['GetChannelMessagesByMsgChannelId']['edges']} ");

                                                                        // (msg_count_display.length !=
                                                                        //         ids.length)
                                                                        //     ? msg_count_display.add(channelResult.data!['GetChannelMessagesByMsgChannelId']['edges'].length.toString())
                                                                        //     : print('Nothing');
                                                                        msg_count_display[
                                                                            ids[index]
                                                                                .toString()] = channelResult
                                                                            .data!['GetChannelMessagesByMsgChannelId']['edges']
                                                                            .length
                                                                            .toString();
                                                                        // Obtain shared preferences.
                                                                        // displayUnreadCount();

                                                                        // cacheData(
                                                                        //     msg_count_display);
                                                                        print(
                                                                            "Here $unreadCountList $msg_count_display $channelResult");

                                                                        msgs = channelResult.data ==
                                                                                null
                                                                            ? []
                                                                            : (channelResult.data!['GetChannelMessagesByMsgChannelId']['edges']);
                                                                        count =
                                                                            [];
                                                                        var chatMsg2;
                                                                        var splits2 =
                                                                            '';
                                                                        var j;
                                                                        for (j =
                                                                                0;
                                                                            j < msgs.length;
                                                                            j++) {
                                                                          var start;
                                                                          var ext;
                                                                          chatMsg2 =
                                                                              msgs[j];
                                                                          splits2 =
                                                                              chatMsg2['node']['msg_media_content'];
                                                                          // log("HI1: ${splits2}");
                                                                          if (splits2
                                                                              .isNotEmpty) {
                                                                            List
                                                                                images =
                                                                                splits2.split(',');
                                                                            print("INSIDE 1234 $images");
                                                                            for (int i = 0;
                                                                                i < images.length;
                                                                                i++) {
                                                                              start = images[i].lastIndexOf('.');
                                                                              ext = images[i].substring(start + 1);
                                                                              if (ext == "jpg" || ext == "jpeg" || ext == "png") {
                                                                                if (images.length == 1) {
                                                                                  fileCount[images[i]] = 1;
                                                                                } else {
                                                                                  fileCount[images[i]] = 2;
                                                                                }
                                                                              }
                                                                            }
                                                                          }
                                                                        }
                                                                        print(
                                                                            'HereABCD12 ${msg_count_display[ids[index].toString()]}');
                                                                        return GestureDetector(
                                                                          behavior:
                                                                              HitTestBehavior.translucent,
                                                                          onTap:
                                                                              () async {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => ChatScreen(
                                                                                          channelID: ids[index].toString(),
                                                                                          token: widget.token,
                                                                                          studentID: widget.parentStudnetid == null ? widget.id.toString() : widget.parentStudnetid.toString(),
                                                                                          channelDescription: channelLists.data!["nodes"][index]["channel_desc"],
                                                                                          channelName: channelLists.data!["nodes"][index]["channel_name"],
                                                                                          channelTopic: channelLists.data!["nodes"][index]["channel_topic"],
                                                                                          images: fileCount,
                                                                                          cachedMap: unreadCountList,
                                                                                          currentMap: msg_count_display,
                                                                                        )));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.all(width * .02),
                                                                            child:
                                                                                Text(
                                                                              channelLists.data!["nodes"][index]["channel_name"],
                                                                              style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 17, fontWeight: FontWeight.bold),
                                                                              overflow: TextOverflow.fade,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      })),
                                                              Expanded(
                                                                flex: 1,
                                                                child: (msg_count_display[ids[index].toString()].toString() !=
                                                                            '0' ||
                                                                        msg_count_display[ids[index].toString()].toString() !=
                                                                            'null')
                                                                    ? Center(
                                                                        child:
                                                                            CircleAvatar(
                                                                          backgroundColor:
                                                                              Colors.blue,
                                                                          radius:
                                                                              width * .03,
                                                                          child:
                                                                              //  height: 20.0*height,
                                                                              Text(
                                                                            // (count[index]-reads[index]).toString(),
                                                                            // "${(count[index]-reads[index]).toString()}",
                                                                            // (msg_count_display.length ==
                                                                            //         ids
                                                                            //             .length)
                                                                            //     // ? (int.parse(msg_count_display[index]) - int.parse(unreadCountList[index]))
                                                                            //     //     .toString()
                                                                            //     ? (msgs.length - reads[index])
                                                                            //         .toString()
                                                                            //     : (msgs.length - reads[index])
                                                                            //         .toString(),
                                                                            // ((msg_count_display[ids[index].toString()] !=
                                                                            //     null) && unreadCountList[ids[index].toString()]!='null')
                                                                            // ? (int.parse(msg_count_display[ids[index].toString()].toString()) - int.parse(unreadCountList[ids[index].toString()].toString()))
                                                                            //     .toString()
                                                                            // : '0',
                                                                            // (int.parse(msg_count_display[ids[index].toString()].toString()) - int.parse(unreadCountList[ids[index].toString()].toString()))
                                                                            //     .toString(),
                                                                            msg_count_display[ids[index].toString()].toString(),
                                                                            // '10',
                                                                            //  reads[index].toString(),
                                                                            //count[index].toString(),
                                                                            //"14",
                                                                            style:
                                                                                TextStyle(fontSize: 12, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Center(
                                                                        child:
                                                                            CircleAvatar(
                                                                          backgroundColor:
                                                                              Colors.blue,
                                                                          radius:
                                                                              width * .03,
                                                                          child:
                                                                              //  height: 20.0*height,
                                                                              Text(
                                                                            // (count[index]-reads[index]).toString(),
                                                                            // "${(count[index]-reads[index]).toString()}",
                                                                            // (msg_count_display.length ==
                                                                            //         ids
                                                                            //             .length)
                                                                            //     // ? (int.parse(msg_count_display[index]) - int.parse(unreadCountList[index]))
                                                                            //     //     .toString()
                                                                            //     ? (msgs.length - reads[index])
                                                                            //         .toString()
                                                                            //     : (msgs.length - reads[index])
                                                                            //         .toString(),
                                                                            // ((msg_count_display[ids[index].toString()] !=
                                                                            //     null) && unreadCountList[ids[index].toString()]!='null')
                                                                            // ? (int.parse(msg_count_display[ids[index].toString()].toString()) - int.parse(unreadCountList[ids[index].toString()].toString()))
                                                                            //     .toString()
                                                                            // : '0',
                                                                            // (int.parse(msg_count_display[ids[index].toString()].toString()) - int.parse(unreadCountList[ids[index].toString()].toString()))
                                                                            //     .toString(),
                                                                            '0',
                                                                            // '10',
                                                                            //  reads[index].toString(),
                                                                            //count[index].toString(),
                                                                            //"14",
                                                                            style:
                                                                                TextStyle(fontSize: 12, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                              );
                                            })
                                      ],
                                    ),
                                  )
                                : Container()
                            // SizedBox(
                            //     height: height / 2,
                            //     width: width,
                            //     child: ListView(
                            //       children: [

                            //         Wrap(
                            //           children: List.generate(
                            //               4,
                            //               (index) => GestureDetector(
                            //                     onTap: () {
                            //                       //Navigator.push(context, MaterialPageRoute(builder: (context)=>const ChatScreen(channelID: '',)));
                            //                     },
                            //                     child: Container(
                            //                       width: width,
                            //                       height: 70,
                            //                       decoration:
                            //                           const BoxDecoration(
                            //                         border: Border(
                            //                             bottom: BorderSide(
                            //                                 color: Color(
                            //                                     0xff89D5FF),
                            //                                 width: 1)),
                            //                       ),
                            //                       child: Row(
                            //                         children: [
                            //                           Expanded(
                            //                               flex: 2,
                            //                               child: Container(
                            //                                 padding: EdgeInsets
                            //                                     .all(width *
                            //                                         .02),
                            //                                 child:
                            //                                     CircleAvatar(
                            //                                         backgroundColor:
                            //                                             const Color(
                            //                                                 0xffE7E7E7),
                            //                                         radius: height *
                            //                                             .025,
                            //                                         child:
                            //                                             const Center(
                            //                                           child:
                            //                                               Icon(
                            //                                             Icons.person,
                            //                                             color:
                            //                                                 Colors.black,
                            //                                           ),
                            //                                         )),
                            //                               )),
                            //                           Expanded(
                            //                               flex: 8,
                            //                               child: Container(
                            //                                 padding: EdgeInsets
                            //                                     .all(width *
                            //                                         .02),
                            //                                 child: Column(
                            //                                   crossAxisAlignment:
                            //                                       CrossAxisAlignment
                            //                                           .start,
                            //                                   mainAxisAlignment:
                            //                                       MainAxisAlignment
                            //                                           .center,
                            //                                   children: [
                            //                                     Text(
                            //                                       "Sunil",
                            //                                       style: Theme.of(
                            //                                               context)
                            //                                           .textTheme
                            //                                           .bodyText1
                            //                                           ?.copyWith(
                            //                                               fontSize: 17,
                            //                                               fontWeight: FontWeight.bold),
                            //                                       overflow:
                            //                                           TextOverflow
                            //                                               .fade,
                            //                                     ),
                            //                                     Text(
                            //                                       "Hello, How are you",
                            //                                       style: Theme.of(
                            //                                               context)
                            //                                           .textTheme
                            //                                           .bodyText1
                            //                                           ?.copyWith(
                            //                                               fontSize: 12,
                            //                                               fontWeight: FontWeight.w500),
                            //                                       overflow:
                            //                                           TextOverflow
                            //                                               .fade,
                            //                                     ),
                            //                                   ],
                            //                                 ),
                            //                               )),
                            //                           Expanded(
                            //                             flex: 1,
                            //                             child: Center(
                            //                               child:
                            //                                   CircleAvatar(
                            //                                 backgroundColor:
                            //                                     Colors.blue,
                            //                                 radius:
                            //                                     width * .03,
                            //                                 child:
                            //                                     const Text(
                            //                                   '14',
                            //                                   style: TextStyle(
                            //                                       fontSize:
                            //                                           12,
                            //                                       color: Colors
                            //                                           .white),
                            //                                 ),
                            //                               ),
                            //                             ),
                            //                           )
                            //                         ],
                            //                       ),
                            //                     ),
                            //                   )),
                            //         ),
                            //         const SizedBox(
                            //           height: 10,
                            //         ),

                            //       ],
                            //     ),
                            //   )
                          ],
                        );
                      });
                })
          ],
        ),
      ),
    );
  }

  // void displayUnreadCount() async {
  //   final preferences = await SharedPreferences.getInstance();
  //   // unreadCountList = preferences.getString('msgCount') as Map<int, int>;
  //   var getMsgCountFromCache = preferences.getString('msgCount')??{};
  //   unreadCountList =
  //       jsonStringToMap(getMsgCountFromCache.toString());

  // }

  jsonStringToMap(String data) {
    Map<String, String> result = {};
    if (data == '{}') {
      return result;
    }
    List<String> str = data
        .replaceAll("{", "")
        .replaceAll("}", "")
        .replaceAll("\"", "")
        .replaceAll("'", "")
        .split(",");
    for (int i = 0; i < str.length; i++) {
      List<String> s = str[i].split(":");
      result.putIfAbsent(s[0].trim(), () => s[1].trim());
    }
    print('Result $result');
    return result;
  }
}
