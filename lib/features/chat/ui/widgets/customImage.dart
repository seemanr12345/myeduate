import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:myeduate/common/base/size_config.dart';
import 'dart:io' show File, FileMode;

import 'package:path_provider/path_provider.dart';

class CustomImage extends StatefulWidget {
  const CustomImage({Key? key, required this.objectName}) : super(key: key);
  final String objectName;

  @override
  _CustomImageState createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> {
  String apiBaseUrl =
      "https://vwr4z140si.execute-api.ap-south-1.amazonaws.com/Download_Files";

  double height = SizeConfig.screenHeight / 812;
  double width = SizeConfig.screenWidth / 375;
  
  bool expanded=false;
  File? file;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          "assets/images/image.svg",
          width: 33 * width,
          height: 27 * height,
        ),
        Container(
          width: 120.0*width,
          child: expanded ? Image.file(file!) :Text(widget.objectName,
            style:
            Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 15, color: Colors.blue),
          ),
        ),
        IconButton(onPressed: () async {
          String apiUrl="$apiBaseUrl?file_name=${widget.objectName}";
          var response= await http.post(Uri.parse(apiUrl));
          var responseResult= json.decode(response.body);
          print("URL: ${responseResult}");
          final appStorage= await getApplicationDocumentsDirectory();
          List<List<int>> chunks=[];
          int downloaded = 0;
          var request = new http.Request('GET', Uri.parse(responseResult));
          var resp = request.send();

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
              file = new File('${appStorage.path}/${widget.objectName}');
              final Uint8List bytes = Uint8List(r.contentLength!);
              int offset = 0;
              for (List<int> chunk in chunks) {
                bytes.setRange(offset, offset + chunk.length, chunk);
                offset += chunk.length;
              }
              final raf=file!.openSync(mode: FileMode.write);
              await file!.writeAsBytes(bytes);
              String filePath1=file!.path;
            });




            //File file= new File(objectName);
            //await file.writeAsBytes(res.stream.toBytes());


            //final decoded=res.stream.cast();
            //File file=File(decoded);

          })
          ;
          print("First: $expanded");
          if(file!=null){
            print("entered");
            setState(() {
              if(expanded==true){
                expanded=false;
              }
              else{
                expanded=true;
              }
            });
          }
          print("First: $expanded");
        },
          icon: Icon(
            expanded ? Icons.keyboard_arrow_up_sharp :
            Icons.keyboard_arrow_down_sharp,
            size: 15.0*height,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
