import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:myeduate/common/base/size_config.dart';
import 'package:myeduate/features/chat/resource/chatQueries.dart';
import 'package:myeduate/features/files/resources/downloadFile.dart';
import 'package:myeduate/features/files/ui/widgets/file.dart';

class Files extends StatefulWidget {
  const Files({Key? key, this.token, required this.channelID}) : super(key: key);
  final String? token;
  final String channelID;

  @override
  _FilesState createState() => _FilesState();
}

class _FilesState extends State<Files> {

  List<String> files=["MyEduate.doc","Chat.jpeg","Instructions.pdf"];
  DownloadFile downloadFile=DownloadFile();
  var queries = Queries();
  var msgs=[];
  String order="Newest";
  var orders=["Newest","Oldest"];
  TextEditingController _searchEditingController = TextEditingController();
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
            child: Icon(Icons.arrow_back_ios_rounded, color: Color(0xff1A1B1C),)),
        title: Text('Files',
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
    return Padding(
        padding: EdgeInsets.only(top: 20.36*height, left: 14*width, right: 14*width),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20.0*height),
              height: 39.11*height,
              padding: EdgeInsets.fromLTRB(12.56*width, 12.06*height,13.93*width,12.06*height),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8*height)),
                  border: Border.all(
                      color: Color(0xff89D5FF)
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration.collapsed(
                          hintText: 'Search',
                          hintStyle: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0*height,
                              color: Colors.black.withOpacity(0.35)
                          ))
                      ),
                    ),
                  ),
                  Icon(
                    Icons.search_rounded,
                    size: 13.12*height,
                    color: Color(0xffD3D3D3),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "${files.length} Results Found",
                  style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                    fontSize: 12.0*height,
                    color: Color(0xff1A1B1C),
                  )),
                ),
                Row(
                  children: <Widget>[
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        icon: RotatedBox(
                          quarterTurns: 1,
                          child: Icon(
                            Icons.compare_arrows_outlined,
                            color: Color(0xff1264C3),
                            size: 15*height,
                          ),
                        ),
                        value: order,
                        style:  Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
    fontSize: 12.0*height,
    fontWeight: FontWeight.w500,
    color: Color(0xff1264C3),
    )),
                        items: orders.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items,
                              style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                                fontSize: 12.0*height,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff1264C3),
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
                )
              ],
            ),
            Divider(
              color: Color(0xff89D5FF),
              thickness: 0.5*height,
            ),
            Query(
              options: QueryOptions(
                document: gql(queries.messagesQuery),variables: {
                "token":widget.token,
                "msg_channel_id":widget.channelID,
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
                    var media = msgs[index]['node']['msg_media_content'];
                  return media.isNotEmpty ? GestureDetector(
                  onTap: (){
                    downloadFile.onTapDownload(media);
                  },
                    child: CustomFile(
                    name:media,
                    size: '1 MB',
                    ),
                  ) : Container();
                  },
                  );
                },
            ),
          ],
        ),
    );
  }
}
