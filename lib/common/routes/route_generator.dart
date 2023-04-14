import 'package:flutter/material.dart';
import 'package:myeduate/common/base/size_config.dart';
import 'package:myeduate/common/routes/routes.dart';
import 'package:myeduate/features/authentication/ui/login.dart';
import 'package:myeduate/features/chat/ui/chatScreen.dart';
import 'package:myeduate/features/dashboard/dashboard_ui.dart';
import 'package:myeduate/features/files/ui/screens/files.dart';
import 'package:myeduate/features/landing/landing_page.dart';
import 'package:myeduate/features/settings/ui/screens/channel_settings.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.landing:
        return MaterialPageRoute(builder: (context) {
          SizeConfig().init(context);
          return const LandingPage();
        });
      case Routes.dashboard:
        return MaterialPageRoute(builder: (context) {
          SizeConfig().init(context);
          return const DashBoard();
        });
      case Routes.login:
        return MaterialPageRoute(builder: (context) {
          SizeConfig().init(context);
          return const Login();
        }
        );
      
      /*case Routes.channelSettings:
        return MaterialPageRoute(builder: (context) {
          SizeConfig().init(context);
          return const ChannelSettings();
        });*/
     
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
