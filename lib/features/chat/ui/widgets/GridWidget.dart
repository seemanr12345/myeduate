import 'package:flutter/material.dart';
import 'dart:io';
Widget gridWidget(files){
    return Container(
      child: GridView.builder(
          itemCount: files.length,
          gridDelegate:
          const SliverGridDelegateWithMaxCrossAxisExtent(
               maxCrossAxisExtent: 300,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
          itemBuilder: (BuildContext context, int index) {
              return Image.file(File(files[index].path),
                  fit: BoxFit.fill,);
          }),
    );
}