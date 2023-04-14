import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myeduate/features/authentication/bloc/authentication_bloc.dart';
import 'package:myeduate/features/authentication/ui/login.dart';
import 'package:myeduate/features/dashboard/dashboard_ui.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationSuccess) {
         return  const DashBoard();
        } else if (state is AuthenticationUnauthenticated) {
          return const Login();
        }
        // state is AuthenticationLoading
        return const Scaffold(
          backgroundColor:
          Colors.white,
          body: CircularProgressIndicator(),
        );
      },
    );
   // return Login();
  }
}
