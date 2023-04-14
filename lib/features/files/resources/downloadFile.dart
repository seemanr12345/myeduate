import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show File, FileMode;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFile{
  String apiBaseUrl="https://vwr4z140si.execute-api.ap-south-1.amazonaws.com/Download_Files";

  onTapDownload(String objectName) async {
    String apiUrl="$apiBaseUrl?file_name=$objectName";
    var response= await http.post(Uri.parse(apiUrl));
    var responseResult= json.decode(response.body);
   print("URL: ${responseResult}");

    List<List<int>> chunks=[];

    //var req= await http.MultipartRequest('GET',Uri.parse(responseResult), );

    //var res=await req.send();
    //print(res.statusCode);
    int downloaded = 0;
    var request = new http.Request('GET', Uri.parse(responseResult));
    var resp = request.send();

    final appStorage= await getApplicationDocumentsDirectory();

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
        File file = new File('${appStorage.path}/$objectName');
        final Uint8List bytes = Uint8List(r.contentLength!);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        final raf=file.openSync(mode: FileMode.write);
        await file.writeAsBytes(bytes);
        String filePath1=file.path;
        OpenFile.open(filePath1);
        return;
      });




      //File file= new File(objectName);
      //await file.writeAsBytes(res.stream.toBytes());


      //final decoded=res.stream.cast();
      //File file=File(decoded);

    })
      ;
    }
}