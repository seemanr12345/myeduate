import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:myeduate/features/chat/resource/uploadFile.dart';
import 'package:myeduate/features/chat/ui/addText.dart';
import 'package:myeduate/features/chat/ui/channelList.dart';
import 'package:myeduate/features/chat/ui/widgets/ChatWidget.dart';

import 'package:myeduate/features/chat/ui/widgets/customIcon.dart';
import 'package:myeduate/features/settings/ui/screens/channel_settings.dart';
import 'package:path_provider/path_provider.dart';
import '../resource/chatQueries.dart';
import 'dart:io' show File, FileMode, Platform;
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.channelID,
    required this.token,
    required this.studentID,
    required this.channelName,
    required this.channelDescription,
    this.channelTopic,
    required this.images,
    required this.cachedMap,
    required this.currentMap,
  }) : super(key: key);
  final String channelID;
  final String studentID;
  final String? token;
  final String? channelName;
  final String? channelDescription;
  final String? channelTopic;
  final Map<String, int> images;
  final Map<String, String> cachedMap;
  final Map<String, String> currentMap;

  @override
  _ChatScreenState createState() => _ChatScreenState();
  static Map<String, File> imageFiles = {};
  static ScrollController listViewController =
      ScrollController(initialScrollOffset: 0);
  static Map<String, File> images_multiple = {};
}

class _ChatScreenState extends State<ChatScreen> {
  String downloadUrl =
      "https://vwr4z140si.execute-api.ap-south-1.amazonaws.com/Download_Files";
  var isEmojiSelected = false;
  int reload = 10;
  int keyboard_height = 0;
  final viewInsets = EdgeInsets.fromWindowPadding(
      WidgetsBinding.instance.window.viewInsets,
      WidgetsBinding.instance.window.devicePixelRatio);
  _onEmojiSelected(Emoji emoji) {
    print('_onEmojiSelected: ${emoji.emoji}');
  }

  _onBackspacePressed() {
    isEmojiSelected = false;
    print('_onBackspacePressed');
  }

  @override
  void initState() {
    super.initState();
    _focus = FocusNode();
    log("Intro ${widget.images}");
    // widget.messageNumberMap[widget.channelID.toString()] = '100';
    // ChannelList.cacheData(widget.messageNumberMap);
    widget.cachedMap[widget.channelID.toString()] =
        widget.currentMap[widget.channelID.toString()].toString();
    ChannelList.cacheData(widget.cachedMap);
    Future.delayed(Duration.zero, () async {
      List<String> imageNames =
          widget.images.keys.where((k) => widget.images[k] == 1).toList();
      List<String> imageMultiple =
          widget.images.keys.where((k) => widget.images[k] == 2).toList();
      // List<String> dupImageNames = imageNames;
      // print(dupImageNames);
      log('Hey12345 $imageMultiple \n $imageNames');
      for (String resource in imageNames) {
        // objectName = imageNames[k];
        print("going in the images for loop");
        Logger().i(resource);

        var tempList = resource.split(',');
        print('Hello abcd : $resource $tempList ${tempList.length} ');
        log("Inside Loop $tempList $resource $imageNames");
        if (resource.contains('.com')) {
          for (String objectName in tempList) {
            if (objectName.contains('.com')) {
              print('Inside URL $objectName');
              String apiUrl = objectName;
              var response = await http.post(Uri.parse(apiUrl));
              var responseResult = json.decode(response.body);
              print('INside IRL $responseResult');
              List<List<int>> chunks = [];

              int downloaded = 0;
              var request = new http.Request('GET', Uri.parse(responseResult));
              var resp = request.send();

              final appStorage = await getApplicationDocumentsDirectory();

              resp.asStream().listen((http.StreamedResponse r) {
                r.stream.listen((List<int> chunk) {
                  // Display percentage of completion
                  // print('downloadPercentage: ${downloaded / r.contentLength!.toInt() *
                  // 100}');

                  chunks.add(chunk);

                  downloaded += chunk.length;
                }, onDone: () async {
                  // Display percentage of completion
                  // debugPrint(
                  //'downloadPercentage: ${downloaded / r.contentLength!.toInt() *
                  //  100}');

                  // Save the file
                  String fileName =
                      objectName.substring(objectName.lastIndexOf('=') + 1);
                  print('abd123 $fileName');
                  File file = new File('${appStorage.path}/$fileName');
                  final Uint8List bytes = Uint8List(r.contentLength!);
                  int offset = 0;
                  for (List<int> chunk in chunks) {
                    bytes.setRange(offset, offset + chunk.length, chunk);
                    offset += chunk.length;
                  }
                  final raf = file.openSync(mode: FileMode.write);
                  await file.writeAsBytes(bytes);
                  String filePath1 = file.path;
                  print('Object: $objectName');
                  ChatScreen.imageFiles[objectName] = file;

                  log('Response: ${ChatScreen.imageFiles}');
                  // reload_fn();
                });

                //File file= new File(objectName);
                //await file.writeAsBytes(res.stream.toBytes());

                //final decoded=res.stream.cast();
                //File file=File(decoded);
              });
            }
          }
        }
      }

      for (String resource in imageMultiple) {
        // objectName = imageNames[k];
        print("going in the images for loop");
        Logger().i(resource);

        var tempList = resource.split(',');
        print('Hello abcd : $resource $tempList ${tempList.length} ');
        log("Inside Loop $tempList $resource $imageNames");
        if (resource.contains('.com')) {
          for (String objectName in tempList) {
            if (objectName.contains('.com')) {
              print('Inside URL1 $objectName');
              String apiUrl = objectName;
              var response = await http.post(Uri.parse(apiUrl));
              var responseResult = json.decode(response.body);
              print('INside IRL1 $responseResult');
              List<List<int>> chunks = [];

              int downloaded = 0;
              var request = new http.Request('GET', Uri.parse(responseResult));
              var resp = request.send();

              final appStorage = await getApplicationDocumentsDirectory();

              resp.asStream().listen((http.StreamedResponse r) {
                r.stream.listen((List<int> chunk) {
                  // Display percentage of completion
                  // print('downloadPercentage: ${downloaded / r.contentLength!.toInt() *
                  // 100}');

                  chunks.add(chunk);

                  downloaded += chunk.length;
                }, onDone: () async {
                  // Display percentage of completion
                  // debugPrint(
                  //'downloadPercentage: ${downloaded / r.contentLength!.toInt() *
                  //  100}');

                  // Save the file
                  String fileName =
                      objectName.substring(objectName.lastIndexOf('=') + 1);
                  print('abd123 $fileName');
                  File file = new File('${appStorage.path}/$fileName');
                  final Uint8List bytes = Uint8List(r.contentLength!);
                  int offset = 0;
                  for (List<int> chunk in chunks) {
                    bytes.setRange(offset, offset + chunk.length, chunk);
                    offset += chunk.length;
                  }
                  final raf = file.openSync(mode: FileMode.write);
                  await file.writeAsBytes(bytes);
                  String filePath1 = file.path;
                  print('Object1: $objectName');
                  ChatScreen.images_multiple[objectName] = file;

                  log('Response1: ${ChatScreen.images_multiple}');
                  reload_fn();
                });

                //File file= new File(objectName);
                //await file.writeAsBytes(res.stream.toBytes());

                //final decoded=res.stream.cast();
                //File file=File(decoded);
              });
            }
          }
        }
      }
    });
  }

  void reload_fn() {
    setState(() {
      ChatScreen.imageFiles = ChatScreen.imageFiles;
    });
  }

  void printHello() {
    print('Hello World');
  }

  ImagePicker picker = ImagePicker();
  String apiBaseUrl =
      "https://awlhr2uh2d.execute-api.ap-south-1.amazonaws.com/Test_function";
  String added = "False";
  Logger l = Logger();
  UploadFile uploadFile = UploadFile();
  var queries = Queries();
  var searchBarClicked = false;
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchEditingController = TextEditingController();
  final maxLines = 10;
  var msgs = [];
  var start;
  var ext;
  FocusNode _focus = FocusNode();
  //var messages=[];
  int msgNumber = 0;
  String? fileName;
  var scrollDown = true;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  void toggleSearch(bool val) {
    val = !val;
  }

  _animateToLast(List item) {
    //debugPrint('scroll down:${_scrollController.hasClients}');
    if (_scrollController.hasClients && scrollDown) {
      debugPrint('scroll down');
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      setState(() => scrollDown = false);

      //len = item.length;
    }
  }

  bool isEmojiVisible = false;

  @override
  Widget build(BuildContext context) {
    Map<String, int> images2 = widget.images;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Logger().i(widget.token);
    // debugPrint('Hello');
    String dateParser(Map str) {
      DateTime date = DateTime.parse(str['node']['created_at']).toLocal();
      //print(date);
      return DateFormat('dd MMM y').format(date);
    }

    String timeParser(Map str) {
      DateTime date = DateTime.parse(str['node']['created_at']).toLocal();
      //print(date);
      return DateFormat("jm").format(date).toLowerCase();
    }

    return Center(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).primaryColor,
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndDocked,
        appBar: AppBar(
          elevation: 2,
          titleSpacing: 0,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      print(widget.channelID.toString());
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(
                        seconds: 1,
                      ),
                      child: searchBarClicked
                          ? SizedBox(
                              height: height * 0.045,
                              width: width * 0.4,
                              child: Center(
                                child: TextField(
                                  controller: _searchEditingController,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(fontSize: 14),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 0),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: const Icon(Icons.search,
                                          color: Colors.white),
                                      hintText: "Search",
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(fontSize: 14)),
                                ),
                              ),
                            )
                          : Text(widget.channelName!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(fontSize: 18)),
                    ),
                  ),
                  // Text("10 members",
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .bodyText1
                  //         ?.copyWith(fontSize: 13,fontWeight: FontWeight.w600)),
                ],
              )
            ],
          ),
          actions: [
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: searchBarClicked
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                searchBarClicked = false;
                                _searchEditingController.clear();
                              });
                            },
                            child: const Icon(Icons.close)),
                        const SizedBox(
                          width: 15,
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                searchBarClicked = true;
                              });
                            },
                            child: const Icon(Icons.search)),
                        const SizedBox(
                          width: 7,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChannelSettings(
                                          token: widget.token!,
                                          channelID: widget.channelID,
                                          channelName: widget.channelName!,
                                          channelDesc:
                                              widget.channelDescription!,
                                          channelTopic: widget.channelTopic,
                                        )),
                              );
                            },
                            child: const Icon(Icons.info_outline)),
                        const SizedBox(
                          width: 15,
                        )
                      ],
                    ),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: (added == "True")
                  ? (isEmojiSelected)
                      ? 6
                      : 13
                  : 13,
              child: Container(
                padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 5),
                child: Query(
                    options: QueryOptions(
                      document: gql(queries.messagesQuery),
                      variables: {
                        "token": widget.token,
                        "msg_channel_id": widget.channelID,
                        "searchString": _searchEditingController.text,
                        "last": reload
                      },
                      fetchPolicy: FetchPolicy.cacheAndNetwork,
                      //pollInterval: const Duration(seconds: 1),
                    ),
                    builder: (QueryResult channelResult,
                        {VoidCallback? refetch, FetchMore? fetchMore}) {
                      if (channelResult.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      //Logger().i(channelResult.data);
                      var pageInfo = channelResult
                              .data!['GetChannelMessagesByMsgChannelId']
                          ['pageInfo'];
                      FetchMoreOptions opts = FetchMoreOptions(
                        variables: {
                          'after': pageInfo['startCursor'],
                          "last": null
                        },
                        updateQuery: (previousResultData, fetchMoreResultData) {
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
                      var groupedMap = Map<String, List>();
                      print("Testing1234 $msgs");
                      for (var i = 0; i < msgs.length; i++) {
                        chatMsg = msgs[i];
                        var date = dateParser(msgs[i]);
                        if (groupedMap.containsKey(date)) {
                          groupedMap[date]?.add(msgs[i]);
                        } else {
                          groupedMap[date] = [msgs[i]];
                          //Logger().i(groupedMap.keys.toList());
                        }
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
                              variables: {"token": widget.token},
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
                              margin: const EdgeInsets.only(top: 1, bottom: 1),
                              // height: (added == "True")
                              //     ? (isEmojiSelected)
                              //         ? height / 3
                              //         : height / 1.6
                              //     : height/1.4 ,
                              width: width,
                              child: (msgNumber != 0)
                                  ? ChatWidget(
                                      pageInfo,
                                      fetchMore,
                                      opts,
                                      _scrollController,
                                      groupedMap,
                                      context,
                                      widget.token,
                                      queries,
                                      _animateToLast,
                                      start,
                                      ext,
                                      timeParser,
                                      ChatScreen.imageFiles,
                                      height,
                                      width,
                                      widget.studentID)
                                  : Container(
                                      child: const Center(
                                        child: Text(
                                          'Please start a chat here...',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                            );
                          });
                    }),
              ),
            ),
            Expanded(
              flex: (added == "True")
                  ? (isEmojiSelected)
                      ? 7
                      : (WidgetsBinding.instance.window.viewInsets.bottom > 0)
                          ? 5
                          : 3
                  : (WidgetsBinding.instance.window.viewInsets.bottom > 0)
                      ? 3
                      : 2,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      height: height * 0.09,
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: GestureDetector(
                                    onTap: () {
                                      print('ADD: $added');
                                      if (added == "True") {
                                        setState(() {
                                          added = "False";
                                          isEmojiSelected = false;
                                        });
                                      } else {
                                        setState(() {
                                          added = "True";
                                        });
                                      }
                                      FocusScope.of(context).requestFocus();
                                    },
                                    child: Icon(added == "False"
                                        ? Icons.add
                                        : Icons.close))),
                            Mutation(
                                options: MutationOptions(
                                  document: gql(queries.addChatQuery),
                                  update: (cache, result) {
                                    if (result!.hasException) {
                                      print(result.exception);
                                    } else {
                                      print(result.data);
                                    }
                                  },
                                  onCompleted: (dynamic resultData) {
                                    print("data:" + resultData.toString());
                                  },
                                ),
                                builder: (RunMutation mutation,
                                    QueryResult? result) {
                                  return Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                          //   onTap: (){ _onAddPhotoClicked(context);},
                                          onTap: () async {
                                            //fileName= await uploadFile.onAddFileClicked(context, apiBaseUrl, "image");
                                            var file = await uploadFile
                                                .onSelect(context, "image");
                                            print('Inside MultiPick $file');
                                            if (file != null) {
                                              print('Inside file');
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddText(
                                                          type: "image",
                                                          file: file,
                                                          token: widget.token,
                                                          channelID:
                                                              widget.channelID,
                                                          studentID:
                                                              widget.studentID,
                                                          channelDescription: widget
                                                              .channelDescription!,
                                                          channelName: widget
                                                              .channelName!,
                                                          channelTopic: widget
                                                              .channelTopic!,
                                                          imageCount:
                                                              widget.images,
                                                        )),
                                              );
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      const AlertDialog(
                                                        title: Text('Error!'),
                                                        content: Text(
                                                            'Upload Size is bigger than 16MB.'),
                                                      ));
                                            }
                                          },
                                          child: Icon(Icons.photo)));
                                }),
                            Expanded(
                                flex: 6,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  constraints: BoxConstraints(
                                      maxHeight: height * 2,
                                      minHeight: height / 20),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xff89D5FF),
                                          width: 1),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Column(
                                    children: [
                                      Mutation(
                                          options: MutationOptions(
                                            document: gql(queries.addChatQuery),
                                            update: (cache, result) {
                                              if (result!.hasException) {
                                                print(result.exception);
                                              } else {
                                                print(result.data);
                                              }
                                            },
                                            onCompleted: (dynamic resultData) {
                                              print("data:" +
                                                  resultData.toString());
                                            },
                                          ),
                                          builder: (RunMutation mutation,
                                              QueryResult? result) {
                                            return TextField(
                                                onTap: () {
                                                  setState(() {
                                                    isEmojiSelected = false;
                                                    // ChatScreen.listViewController.animateTo(ChatScreen.listViewController.position.maxScrollExtent, duration: Duration(milliseconds: 100), curve: Curves.easeOut);
                                                  });
                                                },
                                                minLines: 1,
                                                maxLines: 2,
                                                focusNode: _focus,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                textInputAction:
                                                    TextInputAction.newline,
                                                controller: _controller,
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  hintText: "Start typing...",
                                                ));
                                          }),
                                    ],
                                  ),
                                )),
                            const SizedBox(width: 5),
                            Mutation(
                              options: MutationOptions(
                                document: gql(queries.addChatQuery),
                                update: (cache, result) {
                                  if (result!.hasException) {
                                    print('Exception: ${result.exception}');
                                  } else {
                                    print('Result1234 ${result.data}');
                                  }
                                },
                                onCompleted: (dynamic resultData) {
                                  print("data:" + resultData.toString());
                                },
                              ),
                              builder:
                                  (RunMutation mutation, QueryResult? result) {
                                return GestureDetector(
                                    onTap: () {
                                      print("inside sending messages");
                                      if (_controller.text.isNotEmpty &&
                                          _controller.text.trim().length != 0) {
                                        print(
                                            'Inside controller text  ${_controller.text} ${widget.token}');

                                        mutation({
                                          "token": widget.token,
                                          "msg_content": _controller.text,
                                          "msg_channel_id": widget.channelID,
                                          "student_id": widget.studentID
                                        });

                                        // widget.cachedMap[widget.channelID
                                        //     .toString()] = (int.parse(widget.currentMap[widget.channelID.toString()].toString())+1).toString();
                                        // ChannelList.cacheData(widget.cachedMap);
                                        print(
                                            'Cached Map: ${widget.cachedMap}');
                                        _controller.clear();
                                        ChatScreen.listViewController.jumpTo(
                                            ChatScreen.listViewController
                                                .position.minScrollExtent);
                                      }
                                      // FocusManager.instance.primaryFocus
                                      //     ?.unfocus();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.send,
                                        color: Colors.blue,
                                      ),
                                    ));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    added == "True"
                        ? Container(
                            color: Colors.white,
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isEmojiSelected = true;
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    });
                                  },
                                  child: CustomIcon(
                                      height: height / 812,
                                      width: width / 375,
                                      icon: Icon(
                                        Icons.emoji_emotions_outlined,
                                        color: Colors.black,
                                        size: 29.33 * height / 812.0,
                                      )),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: CustomIcon(
                                      height: height / 812,
                                      width: width / 375,
                                      icon:
                                          // Icon(
                                          //   Icons.text_fields,
                                          //   color: Color.fromARGB(255, 2, 1, 1),
                                          //   size: 29.33 * height / 812.0,
                                          // )
                                          SvgPicture.asset(
                                              'assets/images/Sticker.svg')),
                                ),
                                Mutation(
                                    options: MutationOptions(
                                      document: gql(queries.addChatQuery),
                                      update: (cache, result) {
                                        if (result!.hasException) {
                                          print(result.exception);
                                        } else {
                                          print(result.data);
                                        }
                                      },
                                      onCompleted: (dynamic resultData) {
                                        print("data:" + resultData.toString());
                                      },
                                    ),
                                    builder: (RunMutation mutation,
                                        QueryResult? result) {
                                      return GestureDetector(
                                          //   onTap: (){ _onAddPhotoClicked(context);},
                                          onTap: () async {
                                            File? file = await uploadFile
                                                .onSelect(context, "camera");
                                            if (file != null &&
                                                file.lengthSync() /
                                                        (1024 * 1024) <
                                                    16) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddText(
                                                          type: "image",
                                                          file: file,
                                                          token: widget.token,
                                                          channelID:
                                                              widget.channelID,
                                                          studentID:
                                                              widget.studentID,
                                                          channelTopic: widget
                                                              .channelTopic!,
                                                          channelName: widget
                                                              .channelName!,
                                                          channelDescription: widget
                                                              .channelDescription!,
                                                          imageCount:
                                                              widget.images,
                                                        )),
                                              );
                                              ChatScreen.imageFiles[file.path
                                                  .split('/')
                                                  .last] = file;
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      const AlertDialog(
                                                        title: Text('Error!'),
                                                        content: Text(
                                                            'Upload Size is bigger than 16MB.'),
                                                      ));
                                            }
                                          },
                                          child: CustomIcon(
                                              height: height / 812,
                                              width: width / 375,
                                              icon: Icon(
                                                Icons.camera_alt_outlined,
                                                color: Colors.black,
                                                size: 29.33 * height / 812.0,
                                              )));
                                    }),
                                Mutation(
                                    options: MutationOptions(
                                      document: gql(queries.addChatQuery),
                                      update: (cache, result) {
                                        if (result!.hasException) {
                                          print(result.exception);
                                        } else {
                                          print(result.data);
                                        }
                                      },
                                      onCompleted: (dynamic resultData) {
                                        print("data:" + resultData.toString());
                                      },
                                    ),
                                    builder: (RunMutation mutation,
                                        QueryResult? result) {
                                      return GestureDetector(
                                          //   onTap: (){ _onAddPhotoClicked(context);},
                                          onTap: () async {
                                            File? file = await uploadFile
                                                .onSelect(context, "file");
                                            if (file != null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddText(
                                                          type: "file",
                                                          file: file,
                                                          token: widget.token,
                                                          channelID:
                                                              widget.channelID,
                                                          studentID:
                                                              widget.studentID,
                                                          channelTopic: widget
                                                              .channelTopic!,
                                                          channelName: widget
                                                              .channelName!,
                                                          channelDescription: widget
                                                              .channelDescription!,
                                                          imageCount:
                                                              widget.images,
                                                        )),
                                              );
                                              ChatScreen.imageFiles[file.path
                                                  .split('/')
                                                  .last] = file;
                                            }
                                          },
                                          child: CustomIcon(
                                              height: height / 812,
                                              width: width / 375,
                                              icon:
                                                  // Icon(
                                                  //   Icons.attach_file_outlined,
                                                  //   color: Colors.black,
                                                  //   size:
                                                  //       29.33 * height / 812.0,
                                                  // )
                                                  SvgPicture.asset(
                                                      'assets/images/Paperclip.svg')));
                                    }),
                              ],
                            ),
                          )
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                    Offstage(
                      offstage: !isEmojiSelected,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                        child: SizedBox(
                          height: height / 844 * 264,
                          child: EmojiPicker(
                              textEditingController: _controller,
                              onEmojiSelected:
                                  (Category category, Emoji emoji) {
                                _onEmojiSelected(emoji);
                              },
                              onBackspacePressed: _onBackspacePressed,
                              config: Config(
                                  columns: 7,
                                  // Issue: https://github.com/flutter/flutter/issues/28894
                                  emojiSizeMax:
                                      32 * (Platform.isIOS ? 1.30 : 1.0),
                                  verticalSpacing: 0,
                                  horizontalSpacing: 0,
                                  gridPadding: EdgeInsets.zero,
                                  initCategory: Category.RECENT,
                                  bgColor: const Color(0xFFF2F2F2),
                                  indicatorColor: Colors.blue,
                                  iconColor: Colors.grey,
                                  iconColorSelected: Colors.blue,
                                  progressIndicatorColor: Colors.blue,
                                  backspaceColor: Colors.blue,
                                  skinToneDialogBgColor: Colors.white,
                                  skinToneIndicatorColor: Colors.grey,
                                  enableSkinTones: true,
                                  showRecentsTab: true,
                                  recentsLimit: 28,
                                  replaceEmojiOnLimitExceed: false,
                                  noRecents: const Text(
                                    'No Recents',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black26),
                                    textAlign: TextAlign.center,
                                  ),
                                  tabIndicatorAnimDuration: kTabScrollDuration,
                                  categoryIcons: const CategoryIcons(),
                                  buttonMode: ButtonMode.MATERIAL)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
