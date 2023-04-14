import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import 'ImageDetails.dart';


class GridWidget extends StatelessWidget{
  const GridWidget(
      {Key? key, required this.imageFiles, required this.media, required this.height})
      : super(key: key);
  final dynamic imageFiles;
  final dynamic media;
  final double height;
  @override
  Widget build(BuildContext context) {
    
    List<String> multiImages=media.split(',');
    log('Inside Grid1 $imageFiles \n $media \n $multiImages');
    print('Grid2 ${imageFiles[multiImages[0]]}');
    return ConstrainedBox(
      constraints: BoxConstraints(

        maxHeight: (multiImages.length<=2)?height*0.15:height*0.30),
      child: GridView.builder(
      
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          crossAxisCount: 2,
        ),
        itemCount: multiImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ImageDetails(
              //         image: imageFiles[media], name: 'Bin'),
              //   ),
              // );
              OpenFile.open(imageFiles[multiImages[index]].path);
            },
            child: Container(
              child: (imageFiles[multiImages[index]]!=null)? Image.file(imageFiles[multiImages[index]]):Image.network('https://myeduate-s3files.s3.ap-south-1.amazonaws.com/'+multiImages[index].toString().substring(multiImages[index].toString().lastIndexOf('=')+1)),
              // child: (imageFiles[multiImages[index]]!=null)? Image.file(imageFiles[multiImages[index]]):Center(child: CircularProgressIndicator(),),
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     fit: BoxFit.cover,
              //     image: NetworkImage('https://myeduate-s3files.s3.ap-south-1.amazonaws.com/'+imageFiles[multiImages[index]].toString().substring(multiImages[index].toString().lastIndexOf('=')+1)),
              //   ),
              // ),
            ),
          );
        },
      ),
    );
  }

}