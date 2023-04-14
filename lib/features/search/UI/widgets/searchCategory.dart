import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class searchCategory extends StatelessWidget {
  IconData iconn;
  String text;
  searchCategory({required this.iconn, required this.text});
  //const searchCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 2),
        Icon(iconn, color: const Color(0xff000000)),
        const SizedBox(width: 12),
        Text(text,
            style: GoogleFonts.josefinSans(fontSize: 14, fontWeight: FontWeight.w500))
      ],
    );
  }
}
