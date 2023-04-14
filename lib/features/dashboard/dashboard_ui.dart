import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myeduate/common/base/size_config.dart';
import 'package:myeduate/features/authentication/resource/user_repository.dart';
import 'package:myeduate/features/chat/ui/channelList.dart';
import 'package:myeduate/features/dashboard/resource/dashboardQueries.dart';
import 'package:myeduate/features/search/UI/screens/searchScreen.dart';

import '../../common/utility/Apputilities.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  void initState() {
    super.initState();
  }

  dynamic token;
  dynamic id;
  dynamic parentsStudentID;
  dynamic studentVal;
  dynamic userType;
  Future<void> getToken() async {
    token = await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  String authDetailQuery = """
    query GetAuthDetails(\$token:String!){
    GetAuthDetailsByToken(token: \$token)
    {
      id
      auth_group_type
    }
    }
  """;

  String staffDetailQuery = """
  query GetStaffDetail(\$token:String!,\$auth_id:ID!)
  {
    GetStaffDetailsByAuthId(token:\$token,auth_id:\$auth_id)
    {
      first_name
      middle_name
      last_name
      id
    }
  }
  """;
  String parentDetailQuery = """
  query GetParentDetail(\$token:String!,\$auth_id:ID!)
  {
    GetParentDetailsByAuthId(token:\$token,auth_id:\$auth_id)
    {
      first_name
      middle_name
      last_name
      id
    }
  }
  """;

  String eduateDetailQuery = """
  query GetEduateDetail(\$token:String!,\$auth_id:ID!)
  {
    GetEduateDetailsByAuthId(token:\$token,auth_id:\$auth_id)
    {
      first_name
      middle_name
      last_name
      id
    }
  }
  """;
  String studentNameQuery = """
  query GetStudentDetail(\$token:String!,\$auth_id:ID!)
  {
    GetStudentDetailsByAuthId(token:\$token,auth_id:\$auth_id)
    {
      first_name
      middle_name
      last_name
      id
    }
  }
  """;
  String selectedChildName = "";
  List students = [];
  List studentName = [];
  var queries = DashboardQueries();
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 854.0;
    double width = MediaQuery.of(context).size.width / 390.0;
    final textTheme = Theme.of(context).textTheme;
    print(parentsStudentID);
    print(selectedChildName);
    print("This is token");

    return FutureBuilder(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          print(token);
          return Scaffold(
            drawer: const NavigationDrawer(),
            appBar: AppBar(
              elevation: 0,
              titleSpacing: 1,
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
                  SizedBox(
                    width: 5 * width,
                  ),
                  Text("Eduate",
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontSize: 18 * height, fontWeight: FontWeight.w500))
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/Bell.svg",
                      height: 24 * height,
                      width: 24 * width,
                    ),
                    SizedBox(width: 11 * width),
                    SvgPicture.asset(
                      "assets/images/MagnifyingGlass.svg",
                      height: 24 * height,
                      width: 24 * width,
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     print("this is the parent student id");
                    //     print(parentsStudentID);
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => SearchScreen(
                    //                 id: parentsStudentID == null
                    //                     ? id.toString()
                    //                     : parentsStudentID.toString(),
                    //                 tokenn: token,
                    //               )),
                    //     );
                    //   },
                    //   child: Icon(Icons.search),
                    // ),
                    SizedBox(width: width * 15)
                  ],
                )
              ],
            ),
            backgroundColor: Theme.of(context).primaryColor,
            body: Query(
                options: QueryOptions(
                  document: gql(
                    authDetailQuery,
                  ),
                  variables: <String, dynamic>{"token": token.toString()},
                ),
                builder: (QueryResult result,
                    {VoidCallback? refetch, FetchMore? fetchMore}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return Center(
                      child: Text(
                        "Fetching Channels",
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 28 * height, fontWeight: FontWeight.w700),
                      ),
                    );
                  }
                  userType =
                      result.data!["GetAuthDetailsByToken"]["auth_group_type"];
                  print("id========");
                  print(result.data!["GetAuthDetailsByToken"]["id"]);
                  print(
                      result.data!["GetAuthDetailsByToken"]["auth_group_type"]);
                  if (userType == null) {
                    return Center(
                      child: Text(
                        "No Channels Found",
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 28 * height, fontWeight: FontWeight.w700),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 19 * width, vertical: 26 * height),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      print(
                                          result.data!["GetAuthDetailsByToken"]
                                              ["auth_group_type"]);
                                      if (result.data!["GetAuthDetailsByToken"]
                                              ["auth_group_type"] ==
                                          "PARENT") {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    3,
                                                child: Query(
                                                  options: QueryOptions(
                                                      document: gql(
                                                          queries.parentsChild),
                                                      variables: {
                                                        "token": token,
                                                        "parent_id": id
                                                      }),
                                                  builder: (QueryResult
                                                          userDetails,
                                                      {VoidCallback? refetch,
                                                      FetchMore? fetchMore}) {
                                                    print(userDetails.data);
                                                    if (userDetails.data ==
                                                        null) {
                                                      print("inised null");
                                                      students = [];
                                                    } else {
                                                      students = [];
                                                      List id = [];
                                                      for (var i in userDetails
                                                              .data![
                                                          "GetParentStudentAssociByParentId"]) {
                                                        students.add(
                                                            i["student_id"]);
                                                        id.add(i["id"]);
                                                        print(students);
                                                        print(id);
                                                      }
                                                    }
                                                    print("after student id");
                                                    print(students);
                                                    print(token);
                                                    //["197568495826","197568495757","197568495743"]
                                                    return Query(
                                                        options: QueryOptions(
                                                            document: gql(queries
                                                                .studentChildDetails),
                                                            variables: {
                                                              "token": token,
                                                              "ids": students,
                                                            }),
                                                        builder: (QueryResult
                                                                studentDetail,
                                                            {VoidCallback?
                                                                refetch,
                                                            FetchMore?
                                                                fetchMore}) {
                                                          print("inside name");
                                                          print(studentDetail
                                                              .data);
                                                          if (studentDetail
                                                                  .data ==
                                                              null) {
                                                            print("null");
                                                            studentName = [];
                                                          } else {
                                                            studentName = [];
                                                            for (var i
                                                                in studentDetail
                                                                        .data![
                                                                    "nodes"]) {
                                                              studentName.add(i[
                                                                  "first_name"]);
                                                              // print(students);
                                                              // print(id);
                                                            }
                                                          }
                                                          print(studentName);
                                                          return ListView(
                                                            children:
                                                                studentName
                                                                    .map((e) {
                                                              return Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: height *
                                                                            1),
                                                                height:
                                                                    height * 1,
                                                                child:
                                                                    RadioListTile<
                                                                        dynamic>(
                                                                  value: e,
                                                                  groupValue:
                                                                      studentVal,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      studentVal =
                                                                          e;
                                                                      selectedChildName =
                                                                          value;
                                                                      parentsStudentID =
                                                                          students
                                                                              .elementAt(studentName.indexOf(value));

                                                                      Navigator.pop(
                                                                          context);
                                                                      print(
                                                                          parentsStudentID);
                                                                      print(
                                                                          selectedChildName);
                                                                    });
                                                                  },
                                                                  activeColor:
                                                                      Colors
                                                                          .blue,
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                          .all(0),
                                                                  title: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            CircleAvatar(
                                                                          backgroundColor:
                                                                              Colors.black,
                                                                          radius:
                                                                              height * 35,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Text(
                                                                          e.toString(),
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyText1
                                                                              ?.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  controlAffinity:
                                                                      ListTileControlAffinity
                                                                          .trailing,
                                                                ),
                                                              );
                                                            }).toList(),
                                                          );
                                                        }); //listviewends
                                                  },
                                                ));
                                          },
                                        );
                                      }
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: width * 38,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 18 * width,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      result.data!["GetAuthDetailsByToken"]["auth_group_type"] ==
                                              "STAFF"
                                          ? Query(
                                              options: QueryOptions(
                                                  document: gql(staffDetailQuery),
                                                  variables: {
                                                    "token": token,
                                                    "auth_id": result.data![
                                                            "GetAuthDetailsByToken"]
                                                        ["id"]
                                                  }),
                                              builder: (QueryResult userDetails,
                                                  {VoidCallback? refetch,
                                                  FetchMore? fetchMore}) {
                                                if (userDetails.data == null) {
                                                  return const Text("");
                                                } else if (userDetails
                                                    .hasException) {
                                                  return Text(
                                                    "Exception Occured",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        ?.copyWith(
                                                            fontSize:
                                                                28 * height,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  );
                                                }
                                                return Text(
                                                  "Hey, ${userDetails.data!["GetStaffDetailsByAuthId"]["first_name"]}",
                                                  // "Hey, \n${userDetails.data!["GetStaffDetailsByAuthId"]["first_name"]} ${userDetails.data!["GetStaffDetailsByAuthId"]["middle_name"]} ${userDetails.data!["GetStaffDetailsByAuthId"]["last_name"]}!",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      ?.copyWith(
                                                          fontSize: 28 * height,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                  overflow: TextOverflow.fade,
                                                );
                                              })
                                          : result.data!["GetAuthDetailsByToken"]
                                                      ["auth_group_type"] ==
                                                  "STUDENT"
                                              ? Query(
                                                  options: QueryOptions(
                                                      document: gql(studentNameQuery),
                                                      variables: {
                                                        "token": token,
                                                        "auth_id": result.data![
                                                                "GetAuthDetailsByToken"]
                                                            ["id"]
                                                      }),
                                                  builder: (QueryResult userDetails,
                                                      {VoidCallback? refetch,
                                                      FetchMore? fetchMore}) {
                                                    if (userDetails.data ==
                                                        null) {
                                                      print(userDetails);
                                                      return const Text("");
                                                    } else if (userDetails
                                                        .hasException) {
                                                      return Text(
                                                        "Exception Occured",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            ?.copyWith(
                                                                fontSize:
                                                                    28 * height,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      );
                                                    }
                                                    id = userDetails.data![
                                                            "GetStudentDetailsByAuthId"]
                                                        ["id"];
                                                    return Text(
                                                      "Hey, ${userDetails.data!["GetStudentDetailsByAuthId"]["first_name"]}",
                                                      // "Hey,\n${userDetails.data!["GetStudentDetailsByAuthId"]["first_name"]} ${userDetails.data!["GetStudentDetailsByAuthId"]["middle_name"]} ${userDetails.data!["GetStudentDetailsByAuthId"]["last_name"]}!",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          ?.copyWith(
                                                              fontSize:
                                                                  28 * height,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                      overflow:
                                                          TextOverflow.fade,
                                                    );
                                                  })
                                              : result.data!["GetAuthDetailsByToken"]
                                                          ["auth_group_type"] ==
                                                      "PARENT"
                                                  ? Query(
                                                      options: QueryOptions(document: gql(parentDetailQuery), variables: {"token": token, "auth_id": result.data!["GetAuthDetailsByToken"]["id"]}),
                                                      builder: (QueryResult userDetails, {VoidCallback? refetch, FetchMore? fetchMore}) {
                                                        if (userDetails.data ==
                                                            null) {
                                                          print(userDetails);
                                                          return const Text("");
                                                        } else if (userDetails
                                                            .hasException) {
                                                          return Text(
                                                            "Exception Occured",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1
                                                                ?.copyWith(
                                                                    fontSize: 28 *
                                                                        height,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          );
                                                        }
                                                        id = userDetails.data![
                                                                "GetParentDetailsByAuthId"]
                                                            ["id"];
                                                        // print("here is parentid");
                                                        // print(id);
                                                        return Text(
                                                          selectedChildName ==
                                                                  ""
                                                              ? "Hey, \n${userDetails.data!["GetParentDetailsByAuthId"]["first_name"]}"
                                                              // ? "Hey, \n${userDetails.data!["GetParentDetailsByAuthId"]["first_name"]} ${userDetails.data!["GetParentDetailsByAuthId"]["middle_name"]} ${userDetails.data!["GetParentDetailsByAuthId"]["last_name"]}!"
                                                              : "Hey $selectedChildName!",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText1
                                                              ?.copyWith(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                          overflow:
                                                              TextOverflow.fade,
                                                        );
                                                      })
                                                  : Query(
                                                      options: QueryOptions(document: gql(eduateDetailQuery), variables: {"token": token, "auth_id": result.data!["GetAuthDetailsByToken"]["id"]}),
                                                      builder: (QueryResult userDetails, {VoidCallback? refetch, FetchMore? fetchMore}) {
                                                        if (userDetails.data ==
                                                            null) {
                                                          print(userDetails);
                                                          return const Text("");
                                                        } else if (userDetails
                                                            .hasException) {
                                                          return Text(
                                                            "Exception Occured",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1
                                                                ?.copyWith(
                                                                    fontSize: 28 *
                                                                        height,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          );
                                                        }
                                                        id = userDetails.data![
                                                                "GetEduateDetailsByAuthId"]
                                                            ["inst_id"];
                                                        print("id");
                                                        print(id);
                                                        return Text(
                                                          "Hey, \n${userDetails.data!["GetEduateDetailsByAuthId"]["first_name"]}",
                                                          // "Hey, \n${userDetails.data!["GetEduateDetailsByAuthId"]["first_name"]} ${userDetails.data!["GetEduateDetailsByAuthId"]["middle_name"]} ${userDetails.data!["GetEduateDetailsByAuthId"]["last_name"]}!",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText1
                                                              ?.copyWith(
                                                                  fontSize: 28 *
                                                                      height,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                          overflow:
                                                              TextOverflow.fade,
                                                        );
                                                      }),
                                      Text(DateFormat.yMMMEd().format(now))
                                    ],
                                  ),
                                ),
                              ]),
                          SizedBox(
                            height: height * 22,
                          ),
                          Text(
                            "Dashboard",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                    fontSize: 18 * height,
                                    fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: height * 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Card(
                                color: Color(0xffE9F6FD),
                                elevation: 5,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14))),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChannelList(
                                                  token: token,
                                                  id: id,
                                                  userType: userType,
                                                  parentStudnetid:
                                                      parentsStudentID,
                                                )));
                                  },
                                  child: SizedBox(
                                    height: height * 97,
                                    width: height * 168,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/ChatText.svg",
                                          height: height * 42,
                                          width: width * 42,
                                        ),
                                        // Icon(
                                        //   Icons.message_outlined,
                                        //   color: Colors.blue,
                                        //   size: height * .04,
                                        // ),
                                        SizedBox(
                                          height: height * 12,
                                        ),
                                        Text(
                                          "Chats",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 5,
                                color: Color(0xffFBEBE7),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14))),
                                child: SizedBox(
                                  height: height * 97,
                                  width: height * 168,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Icon(
                                      //   Icons.calendar_today_outlined,
                                      //   color: Colors.blue,
                                      //   size: height * .04,
                                      // ),
                                      SvgPicture.asset(
                                        "assets/images/CalendarBlank.svg",
                                        height: height * 42,
                                        width: width * 42,
                                      ),
                                      // Icon(
                                      //   Icons.message_outlined,
                                      //   color: Colors.blue,
                                      //   size: height * .04,
                                      // ),
                                      SizedBox(
                                        height: height * 12,
                                      ),
                                      Text(
                                        "Calendar",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: height * 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Card(
                                color: Color(0xffFEF9DE),
                                elevation: 5,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14))),
                                child: SizedBox(
                                  height: height * 97,
                                  width: height * 168,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/Notebook.svg",
                                        height: height * 42,
                                        width: width * 42,
                                      ),
                                      // Icon(
                                      //   Icons.message_outlined,
                                      //   color: Colors.blue,
                                      //   size: height * .04,
                                      // ),
                                      SizedBox(
                                        height: height * 12,
                                      ),
                                      Text(
                                        "Notes",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                color: Color(0xffE8F6F3),
                                elevation: 5,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14))),
                                child: SizedBox(
                                  height: height * 97,
                                  width: height * 168,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // Icon(
                                      //   Icons.notes_outlined,
                                      //   color: Colors.blue,
                                      //   size: height * .04,
                                      // ),
                                      SvgPicture.asset(
                                        "assets/images/UsersThree.svg",
                                        width: width * 42,
                                        height: height * 42,
                                      ),
                                      SizedBox(
                                        height: height * 12,
                                      ),
                                      Text(
                                        "Discussion",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 28 * height,
                          ),
                          Text(
                            "Notifications",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                    fontSize: 18 * height,
                                    fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 16 * height,
                          ),
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: height * 263,
                            ),
                            child: ListView(
                                // implement never scollable physics so that it scrolls with the parent scrollview
                                // physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(top: height * 1),
                                children: [
                                  Wrap(
                                    runSpacing: height * 16,
                                    children: List.generate(
                                        3,
                                        (index) => Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10 * height))),
                                              elevation: 5,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    // borderRadius:
                                                    //     BorderRadius.all(
                                                    //         Radius.circular(
                                                    //             8 * height)),
                                                    border: Border(
                                                        left: BorderSide(
                                                            width: 8.0 * width,
                                                            color: Colors.red
                                                                .shade600))),
                                                height: height * 85,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 12 * height,
                                                      horizontal: 20 * width),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Holiday",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1
                                                                ?.copyWith(
                                                                    fontSize: 15 *
                                                                        height,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                          ),
                                                          Text(
                                                            "1 hour ago",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    12 * height,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          )
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Text(
                                                            'School will remain closed for Saraswati Pooja ',
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1
                                                                ?.copyWith(
                                                                    fontSize: 14 *
                                                                        height,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )),
                                  ),
                                ]),
                          ),
                          // SizedBox(
                          //   height: height * 25,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     Card(
                          //       color: Color(0xffE9F6FD),
                          //       elevation: 5,
                          //       shape: const RoundedRectangleBorder(
                          //           borderRadius:
                          //               BorderRadius.all(Radius.circular(14))),
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) => ChannelList(
                          //                         token: token,
                          //                         id: id,
                          //                         userType: userType,
                          //                         parentStudnetid:
                          //                             parentsStudentID,
                          //                       )));
                          //         },
                          //         child: SizedBox(
                          //           height: height * 97,
                          //           width: height * 168,
                          //           child: Column(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.start,
                          //             children: [
                          //               SvgPicture.asset(
                          //                 "assets/images/ChatText.svg",
                          //                 height: height * 42,
                          //                 width: width * 42,
                          //               ),
                          //               // Icon(
                          //               //   Icons.message_outlined,
                          //               //   color: Colors.blue,
                          //               //   size: height * .04,
                          //               // ),
                          //               SizedBox(
                          //                 height: height * 12,
                          //               ),
                          //               Text(
                          //                 "Chats",
                          //                 style: Theme.of(context)
                          //                     .textTheme
                          //                     .bodyText1
                          //                     ?.copyWith(
                          //                         fontSize: 14,
                          //                         fontWeight: FontWeight.w700),
                          //               )
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     Card(
                          //       elevation: 5,
                          //       color: Color(0xffFBEBE7),
                          //       shape: const RoundedRectangleBorder(
                          //           borderRadius:
                          //               BorderRadius.all(Radius.circular(14))),
                          //       child: SizedBox(
                          //         height: height * 97,
                          //         width: height * 168,
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             // Icon(
                          //             //   Icons.calendar_today_outlined,
                          //             //   color: Colors.blue,
                          //             //   size: height * .04,
                          //             // ),
                          //             SvgPicture.asset(
                          //               "assets/images/CalendarBlank.svg",
                          //               height: height * 42,
                          //               width: width * 42,
                          //             ),
                          //             // Icon(
                          //             //   Icons.message_outlined,
                          //             //   color: Colors.blue,
                          //             //   size: height * .04,
                          //             // ),
                          //             SizedBox(
                          //               height: height * 12,
                          //             ),
                          //             Text(
                          //               "Calendar",
                          //               style: Theme.of(context)
                          //                   .textTheme
                          //                   .bodyText1
                          //                   ?.copyWith(
                          //                       fontSize: 14,
                          //                       fontWeight: FontWeight.w700),
                          //             )
                          //           ],
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: height * 16,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     Card(
                          //       color: Color(0xffFEF9DE),
                          //       elevation: 5,
                          //       shape: const RoundedRectangleBorder(
                          //           borderRadius:
                          //               BorderRadius.all(Radius.circular(14))),
                          //       child: SizedBox(
                          //         height: height * 97,
                          //         width: height * 168,
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             SvgPicture.asset(
                          //               "assets/images/Notebook.svg",
                          //               height: height * 42,
                          //               width: width * 42,
                          //             ),
                          //             // Icon(
                          //             //   Icons.message_outlined,
                          //             //   color: Colors.blue,
                          //             //   size: height * .04,
                          //             // ),
                          //             SizedBox(
                          //               height: height * 12,
                          //             ),
                          //             Text(
                          //               "Notes",
                          //               style: Theme.of(context)
                          //                   .textTheme
                          //                   .bodyText1
                          //                   ?.copyWith(
                          //                       fontSize: 14,
                          //                       fontWeight: FontWeight.w700),
                          //             )
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     Card(
                          //       color: Color(0xffE8F6F3),
                          //       elevation: 5,
                          //       shape: const RoundedRectangleBorder(
                          //           borderRadius:
                          //               BorderRadius.all(Radius.circular(14))),
                          //       child: SizedBox(
                          //         height: height * 97,
                          //         width: height * 168,
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.start,
                          //           children: [
                          //             // Icon(
                          //             //   Icons.notes_outlined,
                          //             //   color: Colors.blue,
                          //             //   size: height * .04,
                          //             // ),
                          //             SvgPicture.asset(
                          //               "assets/images/UsersThree.svg",
                          //               width: width * 42,
                          //               height: height * 42,
                          //             ),
                          //             SizedBox(
                          //               height: height * 12,
                          //             ),
                          //             Text(
                          //               "Discussion",
                          //               style: Theme.of(context)
                          //                   .textTheme
                          //                   .bodyText1
                          //                   ?.copyWith(
                          //                       fontSize: 14,
                          //                       fontWeight: FontWeight.w700),
                          //             )
                          //           ],
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        });
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/channelSettings');
            },
            child: ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              title: Text(
                "Settings",
                style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
                    fontSize: 20.0 * SizeConfig.screenHeight / 812.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1a1b1c))),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              UserRepository().signOut(context);
            },
            child: ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              title: Text(
                "Sign Out",
                style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
                    fontSize: 20.0 * SizeConfig.screenHeight / 812.0,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff1a1b1c))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
