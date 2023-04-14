// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:myeduate/features/directMessage/screens/dmChatlist.dart';
import 'package:myeduate/features/search/UI/widgets/narrowSearches.dart';
import 'package:myeduate/features/search/UI/widgets/searchCategory.dart';
import 'package:myeduate/features/search/resource/searchQueries.dart';
import 'package:textfield_tags/textfield_tags.dart';

//if getting any bindings error go to controller.dart-line no 87 and
//make changes == WidgetsBinding.instance?.addPostFrameCallback((_) {
// ignore: must_be_immutable
class SearchScreen extends StatefulWidget {
  dynamic id;
  dynamic tokenn;
  SearchScreen({Key? key, @required this.id, @required this.tokenn})
      : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  dynamic token;
  dynamic id;
  dynamic userType;
  String userImage = "";
  String search = "";
  bool searched = false;
  String searchedValue = "";
  String placeholderString = 'Search for messages and files';

  // Future<void> getToken() async {
  //   token = await FirebaseAuth.instance.currentUser?.getIdToken();
  // }

  bool showValues = false;
  List recent = [];
  late double _distanceToField;
  void getRecentSearches() async {
    final searchesBox = await Hive.openBox<dynamic>('recentSearches');
    final searchMap = searchesBox.values;
    // ignore: avoid_print
    print(searchMap.length);
    setState(() {
      recent = searchMap.toList();
    });

    searchMap.toList().map((e) => print(e));
    // ignore: avoid_print
    print(searchMap);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  late TextfieldTagsController _controller;
  final focusnode = FocusNode();
  @override
  void initState() {
    focusnode.addListener(() {
      if (focusnode.hasFocus) {
        showOverlay();
      } else {
        hideOverlay();
      }
    });
    _controller = TextfieldTagsController();
    getRecentSearches();
    //getToken();
    // TODO: implement initState
    super.initState();
  }

  //111669149696
  var queries = SearchQueries();

  OverlayEntry? entry;
  final layerLink = LayerLink();
  void showOverlay() {
    final overlay = Overlay.of(context)!;
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    entry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: layerLink,
          child: buildOverlay(),
        ),
      ),
    );
    overlay.insert(entry!);
  }

  hideOverlay() {
    entry?.remove();
    entry = null;
  }

  buildOverlay() {
    return Padding(
      padding: const EdgeInsets.only(top: 46.0),
      child: Material(
        elevation: 4,
        child: Container(
          height: MediaQuery.of(context).size.height * .3,
          //width: MediaQuery.of(context).size.width * .1,
          color: Colors.white,
          child: ListView(
            children: search == "from: @"
                ? students.map((e) {
                    return ListTile(
                      // ignore: prefer_const_constructors
                      leading: CircleAvatar(
                        backgroundColor: Color(0xffe2e8f0),
                        // ignore: prefer_const_constructors
                        child: Center(
                            // ignore: prefer_const_constructors
                            child: Icon(
                          Icons.person,
                          color: Colors.white,
                        )),
                      ),
                      title: Text(e.toString()),
                      onTap: () {
                        _controller.addTag = e;
                        saveRecentSearches(e);
                        hideOverlay();
                        focusnode.unfocus();
                      },
                    );
                  }).toList()
                : search == "in: #"
                    ? channelName.map((e) {
                        return ListTile(
                          leading: Container(
                            height: 44.95,
                            width: 44.95,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                //color: Color(0xffe7e7e7),
                                borderRadius: BorderRadius.circular(10.42)),
                            // ignore: prefer_const_constructors
                            child: Center(
                              // ignore: prefer_const_constructors
                              child: Text("#",
                                  style: TextStyle(color: Color(0xffe7e7e7))),
                              // child: Icon(
                              //   Icons.image,
                              //   color: Colors.black,
                              // ),
                            ),
                          ),
                          title: Text('# ${e.toString()}'),
                          onTap: () {
                            _controller.addTag = e.toString();
                            saveRecentSearches(e);
                            hideOverlay();
                            focusnode.unfocus();
                          },
                        );
                      }).toList()
                    : [""].map((e) {
                        return const Center(child: CircularProgressIndicator());
                      }).toList(),
          ),
        ),
      ),
    );
  }

  List<String> students = [];
  List<dynamic> channel = [];
  List<String> channelName = [];
  String? value;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print(widget.id);
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 1,
          leading: const Icon(
            Icons.menu_outlined,
            color: Colors.black,
          ),
          title: Text("Search",
              style: GoogleFonts.josefinSans(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff000000))),
          // title: Row(children: [
          //   SvgPicture.asset(
          //     'assets/images/myeduate_logo.svg',
          //     height: 20,
          //     width: 30,
          //   ),
          //   const SizedBox(width: 7.2),
          //   Text("Eduate",
          //       style: Theme.of(context)
          //           .textTheme
          //           .bodyText1
          //           ?.copyWith(fontSize: 18))
          // ]),
          actions: [
            Container(
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                  // color: Colors.grey.shade500,
                  borderRadius: BorderRadius.circular(6)),
              child: Icon(
                Icons.notifications_none,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              height: 22,
              width: 22,
              child: Stack(
                children: const [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 22,
                      width: 22,
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        //child: Image.network(userImage),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 6.88,
                      height: 6.88,
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15.5)
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 68,
          decoration: BoxDecoration(
            color: Color(0xff590355),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                  //flex: 1,
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      height: height * .075,
                      child: const Icon(Icons.list, color: Colors.white)),
                  Text("List",
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)),
                  SizedBox(width: 3),
                ],
              )),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => dmChatList()),
                  );
                },
                child: Container(
                    //flex: 1,
                    child: Column(
                  children: [
                    SizedBox(
                        height: height * .075,
                        child: const Icon(Icons.chat, color: Colors.white)),
                    const SizedBox(width: 2),
                    Text("DM's",
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w400))
                  ],
                )),
              ),
              // GestureDetector(
              //   onTap: () {
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(builder: (context) => SearchScreen()),
              //     // );
              //   },
              //   child: Container(
              //     //flex: 1,
              //     child: Column(
              //       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         SizedBox(
              //             height: height * .075,
              //             child: const Icon(Icons.search,color: Colors.white)),
              //              const SizedBox(width: 2),
              //             Text("Search",style: GoogleFonts.inter(
              //               fontSize: 10,
              //               color: Colors.white,
              //               fontWeight: FontWeight.w400
              //               ))
              //       ],
              //     ),
              //   ),
              // ),
              Container(
                  //flex: 1,
                  child: Column(
                children: [
                  SizedBox(
                      height: height * .075,
                      child: const Icon(Icons.dashboard, color: Colors.white)),
                  const SizedBox(width: 2),
                  Text("Dashboard",
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w400))
                ],
              )),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0, right: 15.5),
            child: Container(
              child: Column(
                children: [
                  const SizedBox(height: 15.8),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Container(
                  //     child: Text(
                  //       "Search",
                  //       style: GoogleFonts.ibmPlexSans(
                  //         fontSize: 24,
                  //         fontWeight: FontWeight.w500,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 14.38),
                  CompositedTransformTarget(
                    link: layerLink,
                    child: Container(
                        height: 50.11,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xffe2e8f0))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            search == ""
                                ? Container(width: 0)
                                : SizedBox(
                                    width: 60,
                                    height: 50.11,
                                    child: Center(
                                      child: Text(
                                        search,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                            Center(
                              child: SizedBox(
                                  width: search == "" ? 320 : 268,
                                  height: 50.11,
                                  child: searched
                                      ? Align(
                                          alignment: Alignment.centerLeft,
                                          child: InputChip(
                                            //backgroundColor: ,
                                            label: Text(searchedValue,
                                                style: GoogleFonts.josefinSans(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14)),
                                            onDeleted: () {
                                              setState(() {
                                                searched = !searched;
                                              });
                                            },
                                          ),
                                        )
                                      : Query(
                                          options: QueryOptions(
                                              document: gql(queries.channels),
                                              variables: {
                                                "token": widget.tokenn,
                                                "student_id": widget.id,
                                              },
                                              pollInterval:
                                                  const Duration(seconds: 5),
                                              fetchPolicy:
                                                  FetchPolicy.cacheAndNetwork),
                                          builder: (QueryResult channelResult,
                                              {VoidCallback? refetch,
                                              FetchMore? fetchMore}) {
                                            if (channelResult.data == null) {
                                              print(channelResult);
                                              channel = [];
                                              return Container();
                                            }
                                            channel = [];
                                            for (var i in channelResult.data![
                                                "GetChannelSubscribedByStudentId"]) {
                                              channel.add(i["msg_channel_id"]);
                                            }
                                            print(channel);
                                            print(channel[0]);
                                            return Query(
                                                options: QueryOptions(
                                                    document: gql(queries
                                                        .studentChannelListQuery),
                                                    variables: {
                                                      "token": widget.tokenn,
                                                      "msg_channel_id": channel
                                                              .isNotEmpty
                                                          ? channel.elementAt(0)
                                                          : ""
                                                    },
                                                    pollInterval:
                                                        const Duration(
                                                            seconds: 5),
                                                    fetchPolicy: FetchPolicy
                                                        .cacheAndNetwork),
                                                builder:
                                                    (QueryResult channelResult,
                                                        {VoidCallback? refetch,
                                                        FetchMore? fetchMore}) {
                                                  if (channelResult.data ==
                                                      null) {
                                                    print(channelResult);
                                                    return Container();
                                                  }
                                                  students = [];
                                                  for (var i in channelResult
                                                          .data![
                                                      "GetStudentsByChannelId"]) {
                                                    students
                                                        .add(i["first_name"]);
                                                  }
                                                  return Query(
                                                      options: QueryOptions(
                                                          document: gql(queries
                                                              .nodeQuery),
                                                          variables: {
                                                            "token":
                                                                widget.tokenn,
                                                            "ids":
                                                                channel.length >
                                                                        1
                                                                    ? channel
                                                                    : [
                                                                        channel
                                                                            .elementAt(0),
                                                                        channel
                                                                            .elementAt(0)
                                                                      ]
                                                          }),
                                                      builder: (QueryResult
                                                              channelLists,
                                                          {VoidCallback?
                                                              refetch,
                                                          FetchMore?
                                                              fetchMore}) {
                                                        if (channelLists.data ==
                                                            null) {
                                                          print(channelLists);
                                                          return const Text(
                                                              "No channels Found");
                                                        }
                                                        channelLists
                                                            .data!["nodes"];
                                                        channelName = [];
                                                        for (var i = 0;
                                                            i <
                                                                channelLists
                                                                    .data!
                                                                    .length;
                                                            i++) {
                                                          print(channelLists
                                                                      .data![
                                                                  "nodes"][i]
                                                              ["channel_name"]);
                                                          channelName.add(
                                                              channelLists.data![
                                                                      "nodes"][i]
                                                                  [
                                                                  "channel_name"]);
                                                        }
                                                        print(channelName);
                                                        return TextFieldTags(
                                                          focusNode: focusnode,
                                                          initialTags: [],
                                                          textfieldTagsController:
                                                              _controller,
                                                          textSeparators: const [
                                                            ' ',
                                                            ','
                                                          ],
                                                          letterCase:
                                                              LetterCase.normal,
                                                          inputfieldBuilder:
                                                              (context,
                                                                  tec,
                                                                  fn,
                                                                  error,
                                                                  onChanged,
                                                                  onSubmitted) {
                                                            return ((context,
                                                                sc,
                                                                tags,
                                                                onTagDelete) {
                                                              return TextField(
                                                                controller: tec,
                                                                focusNode: fn,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Search for messages and files',
                                                                  hintStyle:
                                                                      GoogleFonts
                                                                          .josefinSans(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                  ),
                                                                  suffixIcon:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            2.0),
                                                                    child: Icon(
                                                                        Icons
                                                                            .search),
                                                                  ),
                                                                  // prefix:
                                                                  //     Icon(Icons
                                                                  //         .search,color: Colors.grey),
                                                                  isDense: true,
                                                                  enabledBorder:
                                                                      const OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                  border:
                                                                      const OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                  focusedBorder:
                                                                      const OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                  prefixIconConstraints:
                                                                      BoxConstraints(
                                                                          maxWidth:
                                                                              _distanceToField * 0.74),
                                                                  prefixIcon: tags
                                                                          .isNotEmpty
                                                                      ? SingleChildScrollView(
                                                                          controller:
                                                                              sc,
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child: Row(
                                                                              children: tags.map((String tag) {
                                                                            return Container(
                                                                              decoration: const BoxDecoration(
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(20.0),
                                                                                ),
                                                                                color: Colors.grey,
                                                                              ),
                                                                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  InkWell(
                                                                                    child: Text(
                                                                                      search == "in: #" ? '#$tag' : "@$tag",
                                                                                      style: GoogleFonts.inter(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                                                                                    ),
                                                                                    onTap: () {
                                                                                      print("something selected");
                                                                                      print("$tag selected");
                                                                                    },
                                                                                  ),
                                                                                  const SizedBox(width: 4.0),
                                                                                  InkWell(
                                                                                    child: const Icon(
                                                                                      Icons.cancel,
                                                                                      size: 14.0,
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                    onTap: () {
                                                                                      onTagDelete(tag);
                                                                                    },
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            );
                                                                          }).toList()),
                                                                        )
                                                                      : null,
                                                                ),
                                                                onChanged:
                                                                    onChanged,
                                                                onSubmitted:
                                                                    (val) {
                                                                  onSubmitted!(
                                                                      val);
                                                                  saveRecentSearches(
                                                                      val);
                                                                  print(students
                                                                      .contains(
                                                                          val.toUpperCase()));
                                                                  print(val);
                                                                },
                                                              );
                                                            });
                                                          },
                                                        );
                                                      });
                                                });
                                          })),
                            ),
                          ],
                        )
                        //// },
                        ////),
                        ),
                  ),
                  //}),
                  const SizedBox(height: 19.5),
                  searchCategory(
                      iconn: Icons.person_search_outlined,
                      text: "Search People"),
                  const SizedBox(height: 22.85),
                  searchCategory(iconn: Icons.search, text: "Browse Channel"),
                  const SizedBox(height: 20.77),
                  const Divider(color: Color(0xffe2e8f0), thickness: 1),
                  const SizedBox(height: 10.41),
                  recent.isEmpty == false
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Recent Searches",
                                    style: GoogleFonts.josefinSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                // GestureDetector(
                                //   onTap: () async {
                                //     print("inside clear all");
                                //     final searchesBox =
                                //         await Hive.openBox<dynamic>(
                                //             'recentSearches');
                                //     searchesBox.clear();
                                //     getRecentSearches();
                                //   },
                                //   child: Text("Clear all",
                                //       style: GoogleFonts.ibmPlexSans(
                                //         fontSize: 12,
                                //         fontWeight: FontWeight.w500,
                                //         color: const Color(0xff1264C3),
                                //       )),
                                // ),
                              ],
                            ),
                            const SizedBox(height: 12.64),
                            SizedBox(
                                height: 95,
                                child: ListView(
                                    children: recent.reversed.map((e) {
                                  print(e);
                                  Duration diff =
                                      DateTime.now().difference(e['time']);
                                  print(diff.inHours);
                                  return recentSearch(
                                    text: e['value'],
                                    keyy: e['key'],
                                    time: diff.inHours > 24
                                        ? "${diff.inDays} days ago"
                                        : diff.inMinutes < 60
                                            ? "${diff.inMinutes} min ago"
                                            : "${diff.inHours} hour ago",
                                  );
                                }).toList())),
                            const SizedBox(height: 15),
                            const Divider(
                                color: Color(0xffe2e8f0), thickness: 1),
                          ],
                        )
                      : const SizedBox(height: 0, width: 0),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Narrow your Search",
                        style: GoogleFonts.josefinSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          search = "in: #";
                          showValues = true;
                          placeholderString = "";
                        });
                      },
                      child:
                          NarrowSearches(example: "Ex: Class 1A", text: "in:")),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          search = "from: @";
                          showValues = true;
                          placeholderString = "";
                        });
                      },
                      child: NarrowSearches(
                          example: "Ex: Praveen", text: "from:")),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          search = "";
                          showValues = false;
                          placeholderString = 'Search for messages and files';
                        });
                      },
                      child: NarrowSearches(
                          example: "Ex: 20-02-2022", text: "after:"))
                ],
              ),
            ),
          ),
        ));
  }

  Widget recentSearch(
      {required String text, required int keyy, required String time}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          const Icon(Icons.history_rounded),
          const SizedBox(width: 14.2),
          SizedBox(
            width: 130,
            child: Text(
              text,
              style: GoogleFonts.josefinSans(
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .15,
          ),
          SizedBox(
              width: 72,
              child: Text(
                time,
                textAlign: TextAlign.end,
                style: GoogleFonts.josefinSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              )),
          const SizedBox(width: 12.01),
          GestureDetector(
              onTap: () {
                deleteSearches(keyy);
                getRecentSearches();
              },
              child: const Icon(
                Icons.cancel_outlined,
                color: Colors.grey,
              ))
        ],
      ),
    );
  }

  void deleteSearches(int value) async {
    print("delete searches");
    final searchesBox = await Hive.openBox<dynamic>('recentSearches');
    await searchesBox.delete(value);
    print(searchesBox.values.length);
    getRecentSearches();
  }

  void saveRecentSearches(String value) async {
    print("save searches");
    final searchesBox = await Hive.openBox<dynamic>('recentSearches');
    int len = searchesBox.values.length;
    print(len);
    searchesBox.put(len + 1, {
      "value": value,
      "time": DateTime.now(),
      'key': len + 1,
    });
    print(searchesBox.values.length);
    getRecentSearches();
  }
}
