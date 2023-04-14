import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myeduate/common/base/size_config.dart';

class CustomFile extends StatefulWidget {
  const CustomFile({Key? key, required this.name, required this.size})
      : super(key: key);

  final String name;
  final String size;

  @override
  _CustomFileState createState() => _CustomFileState();
}

class _CustomFileState extends State<CustomFile> {
  @override
  Widget build(BuildContext context) {
    int start = widget.name.lastIndexOf('.');
    String ext = widget.name.substring(start + 1);
    double height = SizeConfig.screenHeight / 812;
    double width = SizeConfig.screenWidth / 375;
    return Container(
      margin: EdgeInsets.only(top: 12.99 * height),
      padding: EdgeInsets.only(left: 6.0 * width, bottom: 14.0 * height),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Color(0xff89D5FF),
        width: 0.5 * height,
      ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              (ext == "jpeg" || ext == "png" || ext == "jpg")
                  ? SvgPicture.asset(
                      "assets/images/image.svg",
                      width: 33 * width,
                      height: 27 * height,
                    )
                  : ((ext == "doc" || ext == "docx")
                      ? SvgPicture.asset(
                          "assets/images/doc.svg",
                          width: 24 * width,
                          height: 30 * height,
                        )
                      : SvgPicture.asset(
                          "assets/images/file.svg",
                          width: 24 * width,
                          height: 30 * height,
                        )),
              Padding(
                padding: EdgeInsets.only(left: 17.5 * width),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.name,
                        // ignore: deprecated_member_use
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .merge(TextStyle(
                              color: Colors.black,
                              fontSize: 14.0 * height,
                              fontWeight: FontWeight.w500,
                            ))),
                    /* Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.size,
                          style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
                            color: Colors.black,
                            fontSize: 10*height,
                            fontWeight: FontWeight.w500
                          )),
                        ),
                      ),*/
                  ],
                ),
              )
            ],
          ),
          /*Text(
            '24 Jan 2022',
            style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 10*height,
            )),
          )*/
        ],
      ),
    );
  }
}
