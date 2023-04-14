import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:myeduate/features/chat/resource/chatQueries.dart';
import 'package:myeduate/features/chat/ui/widgets/ChatWidget.dart';
import 'package:myeduate/features/files/resources/downloadFile.dart';
import 'package:myeduate/features/files/ui/widgets/file.dart';


class messageandFileSearch extends StatefulWidget {
  static Map<String, File> imageFiles = {};
  @override
  State<messageandFileSearch> createState() => _messageandFileSearchState();
}

class _messageandFileSearchState extends State<messageandFileSearch> with TickerProviderStateMixin {
  late double _distanceToField;
  List<String> files=["MyEduate.doc","Chat.jpeg","Instructions.pdf"];
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }
  var start;
  var ext;
  int msgNumber = 0;

  @override
  void dispose() {
    super.dispose();
  }

  late TabController _tabController;
   TextEditingController _searchEditingController = TextEditingController();
  String order="Newest";
  var queries = Queries();
  var msgs = [];
  var orders=["Newest","Oldest"];
  DownloadFile downloadFile=DownloadFile();
  ScrollController _scrollController = ScrollController();
  var scrollDown = true;
  int reload = 10;
  String searchVar="";

   _animateToLast(List item) {
    //debugPrint('scroll down:${_scrollController.hasClients}');
    if (_scrollController.hasClients && scrollDown) {
      debugPrint('scroll down');
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      setState(() => scrollDown = false);

      //len = item.length;
    }
  }
  @override
  void initState() {
    _tabController=TabController(length: 2, vsync: this);
    // TODO: implement initState
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
     double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String parser(Map str) {
      DateTime date = DateTime.parse(str['node']['created_at']);
      return DateFormat("h:mm a").format(date).toLowerCase();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(leading: 
      GestureDetector(onTap: (){Navigator.pop(context);},child: Icon(Icons.cancel_outlined,color: Colors.black)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
      title: Text("Search",style:GoogleFonts.josefinSans(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Color(0xff000000)
      )),),
      body: Container(
        height: height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left:15.0,right: 15),
            child: Column(
              children: [
              SizedBox(height: 0),
              TextField(
                controller: _searchEditingController,
            decoration: InputDecoration(
                hintText: 'Search for messages and files',
                contentPadding: const EdgeInsets.all(15),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12))),
            
               ),
              SizedBox(height: 8),
             TabBar(
              controller: _tabController,
              isScrollable: false,
              labelColor: Color(0xff2B6CB0),
              unselectedLabelColor: Color(0xff4a5568),
              labelStyle: GoogleFonts.josefinSans(
              fontSize: 19,
              fontWeight: FontWeight.w700,
           ),
              tabs: [
              Tab(text: "Message",),
              Tab(text: "Files",)
              ]),
              Container(
                color: Colors.white,
                width: double.maxFinite,
                height: 530,
                child: TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    width: width*.9,
                    height:490,
                    child: Column(
                      children: [
                        SizedBox(height:10),
                    Container(
                      width: width*.9,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text(
                          "$msgNumber results found",
                        style:  GoogleFonts.josefinSans(
                         fontSize: 10,
                         fontWeight: FontWeight.w400,
                        ),),
                        Container(
                          child: Row(
                            children: <Widget>[
                      DropdownButtonHideUnderline(
                          child: DropdownButton(
                            icon: RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.compare_arrows_outlined,
                                color: Colors.grey,
                                size: 15,
                              ),
                            ),
                            value: order,
                            style:  Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                             )),
                            items: orders.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items,
                                  style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  )),
                                ),
                              );
                            }).toList(),
                              onChanged:(String? newValue) {
                                setState(() {
                                  order = newValue!;
                                });
                              },
                          ),
                      ),
                  ],
                ),
                        )
                      ],),
                    ),
                    Divider(color: Colors.grey,thickness: 1,),
                    _searchEditingController.text.isEmpty ? Container() : Query(
                        options: QueryOptions(
                          document: gql(queries.messagesQuery),
                          variables: {
                            "token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjJkMjNmMzc0MDI1ZWQzNTNmOTg0YjUxMWE3Y2NlNDlhMzFkMzFiZDIiLCJ0eXAiOiJKV1QifQ.eyJQQVJFTlQiOnRydWUsImlzcyI6Imh0dHBzOi8vc2VjdXJldG9rZW4uZ29vZ2xlLmNvbS9teWVkdWF0ZS00OGZlZSIsImF1ZCI6Im15ZWR1YXRlLTQ4ZmVlIiwiYXV0aF90aW1lIjoxNjYyNzMxMDQxLCJ1c2VyX2lkIjoiMExqMzkycjJTNmZwZzNpaVQyVXZVM2Y0SWM5MiIsInN1YiI6IjBMajM5MnIyUzZmcGczaWlUMlV2VTNmNEljOTIiLCJpYXQiOjE2NjMyNDU3ODksImV4cCI6MTY2MzI0OTM4OSwiZW1haWwiOiJlZHV0QGcuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImVkdXRAZy5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.fVjrrrwYEkGrQ138DNkWQbkxEVbRfh6hf9f5-yyZq6pjn_8LKxs9oSCn1UKm-5F4mfmb3OQ3IqoXDEs2l8qtzFoLV8WqQdDljBbMYIdgO48cDhkJOSQ_KfOg_29KZJG1-QEmuFkKKBQhtagPspVY9xwH4JYXrg4UlWYa3FgJy78L2rr-n6bDnfwHRAyoT7YbmEIlnTs-OPI6MJRPMOJuTqZFAzyLFnrd-UYi6-dcjJWk2t7rXqHFLNrvgdp2cm63DiWEgpmSQzx-srSOmpOglsxW9bdTZwQxzI2TRl3UXIUYuLGWiY03BI9atNCbQix6tnYIOyjjiFrQU4pw8MJC7A",
                            "msg_channel_id": "270582939649",
                            "searchString": _searchEditingController.text,
                            "last": reload
                          },
                          fetchPolicy: FetchPolicy.networkOnly,
                          //pollInterval: const Duration(seconds: 1),
                        ),
                        builder: (QueryResult channelResult,
                            {VoidCallback? refetch, FetchMore? fetchMore}) {
                          if (channelResult.isLoading) {
                            return Container();
                          }
                          print("here is channel result.data");
                          print(channelResult.data);
                          //print(channelResult.data);
                          var pageInfo = channelResult
                                  .data!['GetChannelMessagesByMsgChannelId']
                              ['pageInfo'];
                          FetchMoreOptions opts = FetchMoreOptions(
                            variables: {
                              'after': pageInfo['startCursor'],
                              "last": null
                            },
                            updateQuery:
                                (previousResultData, fetchMoreResultData) {
                              // this function will be called so as to combine both the original and fetchMore results
                              // it allows you to combine them as you would like
                              //msgs = fetchMoreResultData!['GetChannelMessagesByMsgChannelId']['edges'];

                              return fetchMoreResultData;
                            },
                          );
                          msgs = channelResult.data == null
                              ? []
                              : (channelResult
                                      .data!['GetChannelMessagesByMsgChannelId']
                                  ['edges']);
                          //_animateToLast(msgs);
                          var chatMsg;
                          var splits = '';
                          for (var i = 0; i < msgs.length; i++) {
                            chatMsg = msgs[i];
                            splits = chatMsg['node']['msg_media_content'];
                            if (splits.isEmpty) {
                              msgNumber = 1;
                            }
                          }
                          return Subscription(
                              onSubscriptionResult: (result, client) {
                                print("subscription data:" + result.toString());
                                client?.resetStore();
                              },
                              options: SubscriptionOptions(
                                  //fetchPolicy: FetchPolicy.c,
                                  variables: {"token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjJkMjNmMzc0MDI1ZWQzNTNmOTg0YjUxMWE3Y2NlNDlhMzFkMzFiZDIiLCJ0eXAiOiJKV1QifQ.eyJQQVJFTlQiOnRydWUsImlzcyI6Imh0dHBzOi8vc2VjdXJldG9rZW4uZ29vZ2xlLmNvbS9teWVkdWF0ZS00OGZlZSIsImF1ZCI6Im15ZWR1YXRlLTQ4ZmVlIiwiYXV0aF90aW1lIjoxNjYyNzMxMDQxLCJ1c2VyX2lkIjoiMExqMzkycjJTNmZwZzNpaVQyVXZVM2Y0SWM5MiIsInN1YiI6IjBMajM5MnIyUzZmcGczaWlUMlV2VTNmNEljOTIiLCJpYXQiOjE2NjMyNDU3ODksImV4cCI6MTY2MzI0OTM4OSwiZW1haWwiOiJlZHV0QGcuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImVkdXRAZy5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.fVjrrrwYEkGrQ138DNkWQbkxEVbRfh6hf9f5-yyZq6pjn_8LKxs9oSCn1UKm-5F4mfmb3OQ3IqoXDEs2l8qtzFoLV8WqQdDljBbMYIdgO48cDhkJOSQ_KfOg_29KZJG1-QEmuFkKKBQhtagPspVY9xwH4JYXrg4UlWYa3FgJy78L2rr-n6bDnfwHRAyoT7YbmEIlnTs-OPI6MJRPMOJuTqZFAzyLFnrd-UYi6-dcjJWk2t7rXqHFLNrvgdp2cm63DiWEgpmSQzx-srSOmpOglsxW9bdTZwQxzI2TRl3UXIUYuLGWiY03BI9atNCbQix6tnYIOyjjiFrQU4pw8MJC7A"},
                                  //fetchPolicy: FetchPolicy.cacheAndNetwork,
                                  document: gql(
                                    queries.messagesSubscriptions,
                                  )),
                              builder: (QueryResult result) {
                                Logger().i(result);
                                if (result.isConcrete) {
                                  msgs.add({
                                    '__typename': "MsgChannelMessageEdge",
                                    "node": result.data![
                                        'GetChannelMessagesBySubscription'][0]
                                  });
                                }
                                //setState(()=>{});
                                //_focus.hasFocus
                                //WidgetsBinding.instance.window.viewInsets.bottom > 0.0
                                return Container(
                                  margin: EdgeInsets.only(top: 25),
                                  height: WidgetsBinding.instance.window
                                              .viewInsets.bottom >
                                          0.0
                                      ? height / 5
                                      : height / 1.61,
                                  width: width,
                                  child: (msgNumber != 0)
                                      ? ChatWidget(

                                          pageInfo,
                                          fetchMore,
                                          opts,
                                          _scrollController,
                                          msgs,
                                          context,
                                          "eyJhbGciOiJSUzI1NiIsImtpZCI6IjJkMjNmMzc0MDI1ZWQzNTNmOTg0YjUxMWE3Y2NlNDlhMzFkMzFiZDIiLCJ0eXAiOiJKV1QifQ.eyJQQVJFTlQiOnRydWUsImlzcyI6Imh0dHBzOi8vc2VjdXJldG9rZW4uZ29vZ2xlLmNvbS9teWVkdWF0ZS00OGZlZSIsImF1ZCI6Im15ZWR1YXRlLTQ4ZmVlIiwiYXV0aF90aW1lIjoxNjYyNzMxMDQxLCJ1c2VyX2lkIjoiMExqMzkycjJTNmZwZzNpaVQyVXZVM2Y0SWM5MiIsInN1YiI6IjBMajM5MnIyUzZmcGczaWlUMlV2VTNmNEljOTIiLCJpYXQiOjE2NjMyMzMzNDcsImV4cCI6MTY2MzIzNjk0NywiZW1haWwiOiJlZHV0QGcuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImVkdXRAZy5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.cybGPPdxf-VyOl-cwlWjbB4X8l-BqeHShlG2JQ6j37WhR1pP6867iIsrPiuBl1LbiKUfuLRD7Uh_oSzhR6R8jnAx_tPvpDrKIE22FQ5qiQcDrijEYI80UcwOwoDFku5DkWqYTs78Y5htDvQY8Vzl-6uKobpUboFqzTm1XZy0Kp9w6Rqjo9NveczwRWoHvkM2lS34C4nayYHb3wCQoodfkbazDpbKoX0C3bRccNDdB4eZs9CZuIXJSOx8EFHWnrKwWBSGAsag17Cxnu0etfz_8f_RNxlWS9d0tzjawHFY63yr3ItGdiqANwrkMV_xEYrrVFMBvXztY_XwjgOoktWHDg",
                                          queries,
                                          _animateToLast,
                                          start,
                                          ext,
                                          parser,
                                          messageandFileSearch.imageFiles,
                                          height,
                                          width)
                                      : Container(
                                          child: const Center(
                                            child: Text(
                                              'Please start a chat here...',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                );
                              });
                        }),
                  ],),),
                  //Container(),
                  Column(
                    children: [
                      SizedBox(height:10),
                      Container(
                      width: width*.9,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text(
                          "${files.length} Results Found",
                        style:  GoogleFonts.josefinSans(
                         fontSize: 10,
                         fontWeight: FontWeight.w400,
                        ),),
                        Container(
                          child: Row(
                            children: <Widget>[
                      DropdownButtonHideUnderline(
                          child: DropdownButton(
                            icon: RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.compare_arrows_outlined,
                                color: Colors.grey,
                                size: 15,
                              ),
                            ),
                            value: order,
                            style:  Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                             )),
                            items: orders.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items,
                                  style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  )),
                                ),
                              );
                            }).toList(),
                              onChanged:(String? newValue) {
                                setState(() {
                                  order = newValue!;
                                });
                              },
                          ),
                      ),
                  ],
                ),
                        )
                      ],),
                    ),
                    Divider(color: Colors.grey,thickness: 1,),
                      Container(
                        child:
                        _searchEditingController.text ==null ? Container() :  Query(
                 options: QueryOptions(
                document: gql(queries.messagesQuery),
                variables: {
                "token":"eyJhbGciOiJSUzI1NiIsImtpZCI6IjJkMjNmMzc0MDI1ZWQzNTNmOTg0YjUxMWE3Y2NlNDlhMzFkMzFiZDIiLCJ0eXAiOiJKV1QifQ.eyJQQVJFTlQiOnRydWUsImlzcyI6Imh0dHBzOi8vc2VjdXJldG9rZW4uZ29vZ2xlLmNvbS9teWVkdWF0ZS00OGZlZSIsImF1ZCI6Im15ZWR1YXRlLTQ4ZmVlIiwiYXV0aF90aW1lIjoxNjYyNzMxMDQxLCJ1c2VyX2lkIjoiMExqMzkycjJTNmZwZzNpaVQyVXZVM2Y0SWM5MiIsInN1YiI6IjBMajM5MnIyUzZmcGczaWlUMlV2VTNmNEljOTIiLCJpYXQiOjE2NjMyMjk4NzQsImV4cCI6MTY2MzIzMzQ3NCwiZW1haWwiOiJlZHV0QGcuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImVkdXRAZy5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.RPkihf6cuXDiNTl1a7WGjRlnLZE8aDjNxlEPai98844EGKlcp0ko43c6g1XTkliI5TH4YgvpifhrOIdyPMJ7HzjjK1Tk-NVJMILi0JodLhq2aHcPusdr7PdiFs4yKl-OZ-8ZDabjDEFBVqf0Kp4j65ChRRl2nMmJsk9cWN-edXYLRfEz6K0q2nllWWy7kqxMhX8KnCsomtCMo_P9ro-js2wr8dhvmPhUaXSIQfy55fJ_IxMKswge8EqtcFC_txjtS-G6fgafq3IruBMNJTtwovC3DfjRhPd_28ZgjiZNVC0dOsJBKnK601_LDCj9LUbQ9aAnSEcgRbKoul_zLtw4sA",
                "msg_channel_id":"270582939649",
                "searchString":_searchEditingController.text
              },
                fetchPolicy: FetchPolicy.cacheAndNetwork,
                //pollInterval: const Duration(seconds: 1),
              ),
                builder: (QueryResult channelResult, { VoidCallback? refetch, FetchMore? fetchMore }){
                      if(channelResult.isLoading)
                      {
                        return Container();
                      }
                      msgs = channelResult.data==null?[]:(channelResult.data!['GetChannelMessagesByMsgChannelId']['edges']);
                      return ListView.builder(
                      reverse: order=="Newest" ? true : false,
                      shrinkWrap: true,
                      itemCount: msgs.length,
                      itemBuilder: (context,int index){
                      var split=msgs[index]['node']['msg_content'].split(":");
                      return split[0]=="FILE" ? GestureDetector(
                      onTap: (){
                        downloadFile.onTapDownload(split[1]);
                      },
                        child: CustomFile(
                        name:split[1],
                        size: '1 MB',
                        ),
                      ) : Container();
                      },
                      );
                },
            ),),
                    ],
                  ),
                  ]
                  ))
            ],),
          ),
          ),
        ),
      );
  }
}