import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({Key? key, required this.height, required this.width, required this.icon}) : super(key: key);
  final double height;
  final double width;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.53*width,
      height: 39.11*height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Color(0xffE9F6FD),
      ),
      child: Align(
        alignment: Alignment.center,
        child: icon,
      ),
    );
  }
}
