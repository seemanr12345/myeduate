
import 'package:flutter/material.dart';

class ImageDetails extends StatelessWidget {
  final String image;
  final String name;

  const ImageDetails({Key? key, required this.image, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: SizedBox(
            width: double.infinity,
            child: Image(
              image: NetworkImage('https://myeduate-s3files.s3.ap-south-1.amazonaws.com/'+image),
              semanticLabel: name,
            ),
          ),
        ),
      ),
    );
  }
}