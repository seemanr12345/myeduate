import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NarrowSearches extends StatelessWidget {
  String text;
  String example;
  NarrowSearches({required this.text, required this.example});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            height: 34.5,
            width: 34.5,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                width: 2,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 36, child: Text(text,style: GoogleFonts.josefinSans(fontSize:12,fontWeight: FontWeight.w300))),
          SizedBox(width: MediaQuery.of(context).size.width * .38),
          SizedBox(
            width: 110,
            child: Text(
              example,
              textAlign: TextAlign.end,
              style: GoogleFonts.josefinSans(fontSize:12,fontWeight: FontWeight.w300)
            ),
          ),
        ],
      ),
    );
  }
}
