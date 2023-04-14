import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myeduate/features/chat/ui/messageandFileSearch.dart';

class dmChatList extends StatelessWidget {
  const dmChatList({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: SizedBox( 
          height:50,
          width:50,
          child:FloatingActionButton(
            backgroundColor: Colors.black,
              child: Icon(Icons.edit), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13)
              ),
              onPressed: (){
                print("Button is pressed.");
              },
            ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 1,
          leading: const Icon(
            Icons.menu_outlined,
            color: Colors.black,
          ),
          title: Text("Direct Message",
          style:GoogleFonts.josefinSans(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Color(0xff000000)
            )),
          actions: [
             Container(
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                // color: Colors.grey.shade500,
                borderRadius: BorderRadius.circular(6)
                ),
              child: Icon(
                Icons.notifications_none,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              height: 22,
              width: 22,
              child: Stack(
                children: const [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 22,
                      width: 22,
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        //child: Image.network(userImage),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 6.88,
                      height: 6.88,
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15.5)
          ],
        ),
      body: Container(
          height: MediaQuery.of(context).size.height*1,
          child: SingleChildScrollView(
            child: Padding(
               padding: const EdgeInsets.only(left: 14.0, right: 15.5),
              child: Column(
              children: [
                SizedBox(height: 30),
                Container(
                    padding: EdgeInsets.all(width * .019),
                    height: height / 17,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: .5),
                    ),
                    child: TextFormField(
                          decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Jump to...",
                          hintStyle: GoogleFonts.josefinSans(fontSize: 13,fontWeight:FontWeight.w300))
                                  )),
                      const SizedBox(height: 10),
                      Wrap(
                                      children: List.generate(
                                          4,
                                              (index) => GestureDetector(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=> messageandFileSearch()));
                                            },
                                            child: Container(
                                              width: width,
                                              height: 70,
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color:
                                                        Colors.white,
                                                        width: 1)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        padding:
                                                        EdgeInsets.all(
                                                            width * .02),
                                                        child: CircleAvatar(
                                                            backgroundColor:
                                                            Color(0xff4299e1),
                                                            radius:
                                                            height * .025,
                                                            child:
                                                            const Center(
                                                              child: Icon(
                                                                Icons.person,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      )),
                                                  Expanded(
                                                      flex: 8,
                                                      child: Container(
                                                        padding:
                                                        EdgeInsets.all(
                                                            width * .02),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Row(mainAxisAlignment:MainAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "Sunil",
                                                                  style: GoogleFonts.josefinSans(fontSize: 12,
                                                                  fontWeight: FontWeight.w700),
                                                                  overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                                ),
                                                                Text(" 2.38 am",
                                                                style: GoogleFonts.josefinSans(fontSize: 10,
                                                                  fontWeight: FontWeight.w400),)
                                                              ],
                                                            ),
                                                            Text(
                                                              "Hello, How are you",
                                                              style: GoogleFonts.josefinSans(fontSize: 10,
                                                                  fontWeight: FontWeight.w400),
                                                              overflow:
                                                              TextOverflow
                                                                  .fade,
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                  Text("just now",
                                                  style: GoogleFonts.josefinSans(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w300),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                    ),
                ],
          ),
            ),),
          ),
        );
  }
}