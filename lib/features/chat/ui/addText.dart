import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import 'package:myeduate/common/base/size_config.dart';
import 'package:myeduate/features/chat/resource/chatQueries.dart';
import 'package:myeduate/features/chat/resource/uploadFile.dart';
import 'package:myeduate/features/chat/ui/chatScreen.dart';
import 'package:myeduate/features/chat/ui/widgets/GridWidget.dart';

class AddText extends StatefulWidget {
  const AddText(
      {Key? key,
      required this.type,
      required this.file,
      required this.token,
      required this.channelID,
      required this.studentID,
      required this.channelDescription,
      required this.channelTopic,
      required this.channelName,
      required this.imageCount})
      : super(key: key);

  final String type;
  final dynamic file;
  final String? token;
  final String? channelID;
  final String? studentID;
  final String channelDescription;
  final String channelTopic;
  final String channelName;
  final Map<String, int> imageCount;

  @override
  _AddTextState createState() => _AddTextState();
}

class _AddTextState extends State<AddText> {
  TextEditingController _controller = TextEditingController();
   String downloadUrl =
      "https://vwr4z140si.execute-api.ap-south-1.amazonaws.com/Download_Files?file_name=";
    String uploadUrl = 'https://myeduate-s3files.s3.ap-south-1.amazonaws.com';
  UploadFile uploadFile = UploadFile();
  var queries = Queries();
  var splits = [];
  int length = 1;
  double height = SizeConfig.screenHeight / 812.0;
  double width = SizeConfig.screenWidth / 375.0;
  String? name;
  FocusNode _focus = FocusNode();
  getLength() async {
    if (widget.file.runtimeType.toString() == "List<dynamic>") {
      length = widget.file.length;
      print("files:" + widget.file.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (mounted) {
      getLength();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> images2 = widget.imageCount;
    if (widget.type == "file") {
      splits = widget.file.path.split("file_picker/");
      name = splits[1];
    }
    String apiBaseUrl =
        "https://awlhr2uh2d.execute-api.ap-south-1.amazonaws.com/Test_function";
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 50.0 * height,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 10.0 * height,
            bottom: 200 * height,
            // left: 50 * width,
            // right: 50 * width),
          ),
          child: (widget.type == "image")
              ? length != 1
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: gridWidget(widget.file))
                  : Center(
                      child: Image.file(
                      widget.file,
                      fit: BoxFit.fitWidth,
                      height:
                          WidgetsBinding.instance.window.viewInsets.bottom > 0.0
                              ? MediaQuery.of(context).size.height * .2
                              : MediaQuery.of(context).size.height * .6,
                    ))
              : Center(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(25.0 * width)),
                        color: Colors.white),
                    padding: EdgeInsets.all(30.0 * height),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 30.0 * height),
                          child: Icon(
                            Icons.file_copy_outlined,
                            color: Colors.black,
                            size: 40 * height,
                          ),
                        ),
                        Text(name!),
                      ],
                    ),
                  ),
                ),
        ),
      ),
      floatingActionButton: SingleChildScrollView(
        child: Mutation(
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
                print("data123:" + resultData.toString());
              },
            ),
            builder: (RunMutation mutation, QueryResult? result) {
              return Row(
                children: [
                  Container(
                    width: 250,
                    margin: EdgeInsets.only(left: 40 * width),
                    padding: const EdgeInsets.fromLTRB(5, 3, 10, 0),
                    constraints: BoxConstraints(
                        maxHeight: height * 2 * 812.0,
                        minHeight: height / 20 * 812.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff89D5FF), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: TextFormField(
                      focusNode: _focus,
                      maxLines: null,
                      textInputAction: TextInputAction.done,
                      controller: _controller,
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        hintText: "Message",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                      onTap: () async {
                        try{
                             Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Container(
                                    width: 50.0 * width,
                                    height: 50.0 * height,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )),
                        );
                        String? fileName;
                        var files = [];
                        Logger().i(length);
                        if (length <= 1) {
                          fileName = await uploadFile.onAddFileClicked(context,
                              apiBaseUrl, widget.file.path, widget.file);
                        } else {
                          for (var file in widget.file) {
                            fileName = await uploadFile.onAddFileClicked(
                                context, apiBaseUrl, file.path, file);
                            files.add(fileName);
                          }
                        }
                        if (fileName != null) {
                          if (files.length > 1) {
                            String multipleFiles='';
                            String multipleFileExt='';
     
                            for(int i=0;i<files.length;i++){
                               int start = files[i].lastIndexOf('.');
                               String ext = files[i].substring(start + 1);
                              multipleFiles+='$downloadUrl'+files[i];
                              if(i!=files.length-1){
                                multipleFiles+=',';
                                multipleFileExt=ext+',';
                              }
                               
                            }
                            Map<String, dynamic> map = {
                              "token": widget.token,
                              "msg_media_content": multipleFiles,
                              "msg_media_type": multipleFileExt,
                              "msg_channel_id": widget.channelID,
                              "student_id": widget.studentID
                            };
                            Logger().i(map);
                            //mutation(map);
                            if (_controller.text != null &&
                                _controller.text != "") {
                              print("text sended");
                              map["msg_content"] = _controller.text;
                            }
                               mutation(map);
                            
                          } else {
                            int start = fileName.lastIndexOf('.');
                            String ext = fileName.substring(start + 1);
                            print("image sent");
                            print('image sent ${fileName.runtimeType}');
                             int start1 = fileName.lastIndexOf('.');
                             String ext1 = fileName.substring(start1 + 1);
                            Map<String, dynamic> map = {
                              "token": widget.token,
                              "msg_media_content": '$downloadUrl'+fileName,
                              "msg_media_type": ext1,
                              "msg_channel_id": widget.channelID,
                              "student_id": widget.studentID
                            };
                            Logger().i(map);
                            //mutation(map);
                            if (_controller.text != null &&
                                _controller.text != "") {
                              print("text sended");
                              map["msg_content"] = _controller.text;
                            }
                            mutation(map);
                          }
                        }
                        images2[widget.file.path.split('/').last] = 1;
                        }
                        catch(e){
                          print(e);
                        }
                        finally{
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      channelID: widget.channelID!,
                                      token: widget.token,
                                      studentID: widget.studentID!,
                                      channelDescription:
                                          widget.channelDescription,
                                      channelName: widget.channelName,
                                      channelTopic: widget.channelTopic,
                                      images: images2,
                                      cachedMap: {},
                                      currentMap: {},
                                    )));
                        }
                       
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      )),
                ],
              );
            }),
      ),
    );
  }
}
