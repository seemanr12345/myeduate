import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myeduate/common/base/size_config.dart';
import 'package:myeduate/common/routes/routes.dart';
import 'package:myeduate/features/authentication/bloc/emailSignIn/email_bloc.dart';
import 'package:myeduate/features/dashboard/dashboard_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late EmailAuthBloc _emailBloc;
  bool _obscureText = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String emailError = "";
  String _email = "";

  @override
  void initState() {
    _emailBloc = BlocProvider.of<EmailAuthBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  void changeVariable() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: _buildContent(),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildContent() {
    double height = MediaQuery.of(context).size.height / 812.0;
    double width = MediaQuery.of(context).size.width / 375.0;
    return BlocBuilder<EmailAuthBloc, EmailAuthState>(
        bloc: BlocProvider.of<EmailAuthBloc>(context),
        builder: (context, state) {
          if (state is EmailStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 122 * height,
                  bottom: 64 * height,
                  right: 42 * width,
                  left: 42 * width),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Center(
                        child: Column(
                      children: [
                        // SvgPicture.asset(
                        //   'assets/images/logo.svg',
                        //   height: 257 * height,
                        //   width: 291 * width,
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.only(bottom: 44.47 * height),
                        //   child: Text(
                        //     'Eduate',
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .bodyText1!
                        //         .merge(TextStyle(
                        //           fontSize: 42.0 * height,
                        //           fontWeight: FontWeight.w600,
                        //           color: Color(0xff1A1B1C),
                        //         )),
                        //   ),
                        // ),
                        SizedBox(
                          height: height * 64,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Sign in',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .merge(TextStyle(
                                  fontSize: 28.0 * height,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff252729),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: height * 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/At.svg',
                              height: 18 * height,
                              width: 18 * width,
                            ),
                            SizedBox(
                              width: width * 19,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: emailController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!validateEmail(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _email = value!.trim(),

                                // validator: (email) => email != null &&
                                //         !EmailValidator.validate(email)
                                //     ? "Enter a Valid Email"
                                //     : null,

                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .merge(TextStyle(
                                      fontSize: 14.0 * height,
                                      color: const Color(0xff1A1B1C),
                                    )),
                                decoration: InputDecoration(
                                    hintText: "Enter your email",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .merge(TextStyle(
                                            fontSize: 13.0 * height,
                                            color: Colors.black
                                                .withOpacity(0.35)))),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 31,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/Keyhole.svg',
                              height: 18 * height,
                              width: 18 * width,
                            ),
                            SizedBox(
                              width: width * 19,
                            ),
                            Expanded(
                              child: TextFormField(
                                obscureText: _obscureText,
                                controller: passController,
                                validator: (value) =>
                                    value != null && value.length < 5
                                        ? "Field Must contain 5 characters"
                                        : null,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .merge(TextStyle(
                                      fontSize: 14.0 * height,
                                      color: const Color(0xff1A1B1C),
                                    )),
                                decoration: InputDecoration(
                                  hintText: "Enter your password",
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .merge(TextStyle(
                                          fontSize: 13.0 * height,
                                          color:
                                              Colors.black.withOpacity(0.35))),
                                  suffixIcon: GestureDetector(
                                      onTap: changeVariable,
                                      child: Icon(_obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 16,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff007CC0),
                                fontSize: height * 13),
                          ),
                        )
                      ],
                    )),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       top: 30.0 * height, bottom: 12.44 * height),
                    //   child: Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Text(
                    //       'Email',
                    //       style: Theme.of(context)
                    //           .textTheme
                    //           .bodyText1!
                    //           .merge(TextStyle(
                    //             fontSize: 18.0 * height,
                    //             fontWeight: FontWeight.w500,
                    //             color: const Color(0xff252729),
                    //           )),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.only(
                    //     left: 10.14 * width,
                    //     top: 10.06 * height,
                    //   ),
                    //   height: 39.11 * height,
                    //   decoration: BoxDecoration(
                    //       borderRadius:
                    //           BorderRadius.all(Radius.circular(8.0 * height)),
                    //       border: Border.all(
                    //           color: const Color(0xff89D5FF),
                    //           width: 0.6 * height)),
                    //   child: TextField(
                    //     onChanged: (String emailNew) {
                    //       if (emailNew.isNotEmpty) {
                    //         setState(() {
                    //           email = emailNew.trim();
                    //         });
                    //       }
                    //     },
                    //     style: Theme.of(context)
                    //         .textTheme
                    //         .titleSmall!
                    //         .merge(TextStyle(
                    //           fontSize: 14.0 * height,
                    //           color: const Color(0xff1A1B1C),
                    //         )),
                    //     decoration: InputDecoration.collapsed(
                    //         hintText: 'Enter your email',
                    //         hintStyle: Theme.of(context)
                    //             .textTheme
                    //             .titleSmall!
                    //             .merge(TextStyle(
                    //                 fontSize: 12.0 * height,
                    //                 color: Colors.black.withOpacity(0.35)))),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       top: 18.79 * height, bottom: 12.0 * height),
                    //   child: Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Text(
                    //       'Password',
                    //       style: Theme.of(context)
                    //           .textTheme
                    //           .bodyText1!
                    //           .merge(TextStyle(
                    //             fontSize: 18.0 * height,
                    //             fontWeight: FontWeight.w500,
                    //             color: const Color(0xff1A1B1C),
                    //           )),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.only(
                    //     left: 10.14 * width,
                    //     top: 10.06 * height,
                    //   ),
                    //   height: 39.11 * height,
                    //   decoration: BoxDecoration(
                    //       borderRadius:
                    //           BorderRadius.all(Radius.circular(8.0 * height)),
                    //       border: Border.all(
                    //           color: const Color(0xff89D5FF),
                    //           width: 0.6 * height)),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(bottom: 6.0),
                    //     child: TextField(
                    //       onChanged: (String passwordNew) {
                    //         if (passwordNew.isNotEmpty) {
                    //           setState(() {
                    //             password = passwordNew;
                    //           });
                    //         }
                    //       },
                    //       style: Theme.of(context)
                    //           .textTheme
                    //           .titleSmall!
                    //           .merge(TextStyle(
                    //             fontSize: 14.0 * height,
                    //             color: const Color(0xff1A1B1C),
                    //           )),
                    //       obscureText: _obscureText,
                    //       decoration: InputDecoration(
                    //         hintText: 'Enter your password',
                    //         hintStyle:
                    //             Theme.of(context).textTheme.titleSmall!.merge(
                    //                   TextStyle(
                    //                     fontSize: 12.0 * height,
                    //                     color: Colors.black.withOpacity(0.35),
                    //                   ),
                    //                 ),
                    //         border: InputBorder.none,
                    //         suffixIcon: GestureDetector(
                    //           onTap: changeVariable,
                    //           child: Icon(_obscureText
                    //               ? Icons.visibility
                    //               : Icons.visibility_off),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 28 * height,
                    ),
                    GestureDetector(
                      onTap: () {
                        final isValid = formKey.currentState!.validate();
                        if (!isValid) return;
                        _emailBloc.add(LoginWithCredentials(
                            email: emailController.text.trim(),
                            password: passController.text.trim(),
                            context: context));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12 * height),
                        // height: 50.0 * height,
                        // width: 190.0 * width,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(36.0 * height)),
                          color: const Color(0xff1264C3),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Sign In',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .merge(TextStyle(
                                  color: const Color(0xffE7F3FF),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20.0 * height,
                                )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20 * height,
                    ),
                    InkWell(
                      onTap: () {
                        print("Sign Up will be implemented");
                      },
                      child: RichText(
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: DefaultTextStyle.of(context).style,
                              children: const <TextSpan>[
                            TextSpan(
                                text: 'Register',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff007CC0))),
                          ])),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  // Function by PRINCE TOMAR

  bool validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Sign In Error"),
          content:
              const Text("Enter valid login credentials" + "\n" + "Try again"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                padding: const EdgeInsets.all(14),
                child: const Text(
                  "okay",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      setState(() {
        emailError = "Email is invalid\nEnter a valid Email";
      });
      return false;
    } else {
      return true;
    }
  }
}
