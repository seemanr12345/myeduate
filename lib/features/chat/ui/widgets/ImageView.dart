import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';


Widget imageView(imageFiles,media,text,width,height,context){
  log('Helloabcd ${imageFiles[media]}');
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              OpenFile.open(
                  imageFiles[media]!.path);
                  print('Inside OnTap ${imageFiles}');
            },
            child: Container(
              width: width,
              child: (imageFiles[media]!=null)?
              Image.file(
                  imageFiles[media]!):Image.network('https://myeduate-s3files.s3.ap-south-1.amazonaws.com/'+media)
              // Image.network(imageFiles[media])
            ),
                  ),
          
          text.isNotEmpty?Text(text,style: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(fontSize: 17)):SizedBox()
        ],
      ),
    );
}
