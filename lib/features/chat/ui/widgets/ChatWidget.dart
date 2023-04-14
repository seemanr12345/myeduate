import 'dart:developer';
// import 'dart:ffi';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:logger/logger.dart';
import 'package:myeduate/features/chat/ui/chatScreen.dart';
import 'package:myeduate/features/chat/ui/widgets/GridImageWidget.dart';
import 'package:myeduate/features/chat/ui/widgets/GridWidget.dart';
import 'package:myeduate/features/chat/ui/widgets/ImageView.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'customFile.dart';

Widget ChatWidget(
    pageInfo,
    fetchMore,
    opts,
    _scrollController,
    groupedMap,
    context,
    token,
    queries,
    _animateToLast,
    start,
    ext,
    parser,
    imageFiles,
    height,
    width,
    [studentID]) {
  var isSelected = false;
  var mycolor = Colors.white;
  var keys = groupedMap.keys.toList();
  return NotificationListener<OverscrollNotification>(
    onNotification: (value) {
      if (value.overscroll < 0 &&
          _scrollController.offset + value.overscroll <= 0) {
        if (pageInfo['hasPreviousPage']) {
          fetchMore!(opts);
          if (_scrollController.offset !=
              _scrollController.position.maxScrollExtent) {
            _scrollController
                .jumpTo(_scrollController.position.minScrollExtent + 100);
            return true;
          }
        }
      } else if (_scrollController.offset + value.overscroll >=
          _scrollController.position.maxScrollExtent) {
        print("Bottom");
        if (_scrollController.offset != 0) _scrollController.jumpTo(0);
        return true;
      }
      print("random");
      _scrollController.jumpTo(_scrollController.offset + value.overscroll);
      return true;
    },
    child: Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                // controller: _scrollController,
                shrinkWrap: true,
                itemCount: keys.length,
                itemBuilder: (BuildContext context, int i) {
                  WidgetsBinding.instance.scheduleFrameCallback(
                      (_) => _animateToLast(keys),
                      rescheduling: false);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            height: height * 0.001,
                            width: width / 3.5,
                            color: Color.fromRGBO(137, 213, 255, 1),
                          ),
                          Center(
                              child: Text(
                            keys[i],
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            height: height * 0.001,
                            width: width / 3.5,
                            color: Color.fromRGBO(137, 213, 255, 1),
                          ),
                        ],
                      ),
                      ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: groupedMap[keys[i]].length,
                        controller: ChatScreen.listViewController,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Query(
                                options: QueryOptions(
                                    document: gql(queries.getIDsQuery),
                                    fetchPolicy: FetchPolicy.cacheAndNetwork,
                                    variables: {
                                      "token": token,
                                      "student_id": groupedMap[keys[i]][index]
                                          ['node']['student_id'],
                                    }),
                                builder: (QueryResult channelResult,
                                    {VoidCallback? refetch,
                                    FetchMore? fetchMore}) {
                                  if (channelResult.isLoading) {
                                    return Container();
                                  }
                                  var temp = channelResult.data![
                                      'GetAcctDemandMainStudentDemandByStudentId'][0];
                                  String name = temp['first_name'].toString() +
                                      " " +
                                      temp['middle_name'].toString() +
                                      " " +
                                      temp['last_name'].toString();

                                  //print(temp);
                                  var split = groupedMap[keys[i]][index]['node']
                                      ['msg_content'];
                                  var media = groupedMap[keys[i]][index]['node']
                                          ['msg_media_content'] ??
                                      '';
                                  print('Hello Media $imageFiles');
                                  // print('Split ${msgs[index]['node']}');

                                  if (media.isNotEmpty) {
                                    // ChatScreen.images_multiple=media.split(',');
                                    // print('start 1: $ChatScreen.images_multipe}');
                                    start = media.lastIndexOf('.');
                                    ext = media.substring(start + 1);

                                    log('Start: $imageFiles $media');
                                  }

                                  return InkWell(
                                    onLongPress: () {
                                      Clipboard.setData(
                                          ClipboardData(text: split));
                                    },
                                    // highlightColor:Colors.blue.withOpacity(0.4) ,

                                    child: ListTile(
                                      // tileColor: color,
                                      isThreeLine: true,
                                      minVerticalPadding: 20,
                                      leading: const CircleAvatar(
                                        minRadius: 20.0,
                                        maxRadius: 25.0,
                                        backgroundColor: Colors.black,
                                      ),
                                      title: RichText(
                                        text: TextSpan(
                                            text: '$name   ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.copyWith(fontSize: 15.5),
                                            children: [
                                              TextSpan(
                                                  text: parser(
                                                      groupedMap[keys[i]]
                                                          [index]),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      ?.copyWith(
                                                          fontSize: 12,
                                                          color: Colors.grey)),
                                            ]),
                                      ),
                                      subtitle: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: (media.isEmpty)
                                            ? Text(split,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    ?.copyWith(fontSize: 17))
                                            : (ext == "jpg" ||
                                                    ext == "jpeg" ||
                                                    ext == "png")
                                                ?
                                                //CustomImage(objectName: split[1])
                                                //img1.png,img2.png

                                                (imageFiles.containsKey(media))
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: imageView(
                                                                  imageFiles,
                                                                  media,
                                                                  split,
                                                                  width,
                                                                  height,
                                                                  context),
                                                            ),
                                                            Expanded(
                                                                flex: 1,
                                                                child:
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          // Download imageFiles[media]
                                                                          await GallerySaver.saveImage(
                                                                              imageFiles[media].path);
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(const SnackBar(content: Text("Image Downloaded to Gallery!")));
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .download,
                                                                        ))),
                                                          ])
                                                    : (ChatScreen
                                                                .images_multiple
                                                                .length >=
                                                            2)
                                                        ? Container(
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        GridWidget(
                                                                      imageFiles:
                                                                          ChatScreen
                                                                              .images_multiple,
                                                                      media:
                                                                          media,
                                                                      height:
                                                                          height,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child: GestureDetector(
                                                                          onTap: () async {
                                                                            // Download imageFiles[media]
                                                                            await GallerySaver.saveImage(imageFiles[media].path);
                                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image Downloaded to Gallery!")));
                                                                          },
                                                                          child: Icon(
                                                                            Icons.download,
                                                                          ))),
                                                                ]),
                                                            // child: Center(child: CircularProgressIndicator()),
                                                          )
                                                        : Container(
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator()))
                                                : CustomDoc(objectName: media),
                                      ),
                                    ),
                                  );
                                }),
                          );
                        },
                      ),
                    ],
                  );
                }),
          )
        ],
      ),
    ),
  );
}
