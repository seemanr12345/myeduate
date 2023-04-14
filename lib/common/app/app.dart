import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:myeduate/common/routes/route_generator.dart';
import 'package:myeduate/common/routes/routes.dart';
import 'package:myeduate/features/authentication/bloc/emailSignIn/email_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myeduate/features/authentication/bloc/authentication_bloc.dart';
import 'package:myeduate/features/authentication/resource/user_repository.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Future<Box> openHiveBox(String boxName) async {
  //   if (!kIsWeb && !Hive.isBoxOpen(boxName)) {
  //     Hive.init((await getApplicationDocumentsDirectory()).path);
  //   }
  //
  //   return await Hive.openBox(boxName);
  // }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final httpLink = HttpLink("http://192.168.0.126:8081/query");
    final WebSocketLink websocketLink = WebSocketLink(
      "ws://159.65.152.5:8081/subscriptions",
      config: const SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: Duration(seconds: 30),
      ),
    );
    ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
        cache: GraphQLCache(store: InMemoryStore()),
        link: httpLink.concat(websocketLink)));
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
          lazy: true,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) {
              return AuthenticationBloc(
                  userRepository:
                      RepositoryProvider.of<UserRepository>(context))
                ..add(AuthStarted());
            },
          ),
          BlocProvider<EmailAuthBloc>(
            create: (context) {
              return EmailAuthBloc(context: context);
            },
          ),
        ],
        child: GraphQLProvider(
          client: client,
          child: MaterialApp(
              title: 'Eduate',
              theme: ThemeData(
                primaryColor: Colors.white,
                textTheme: GoogleFonts.interTextTheme(textTheme).copyWith(
                  bodyText1:
                      GoogleFonts.ibmPlexSans(textStyle: textTheme.bodyText1),
                ),
              ),
              debugShowCheckedModeBanner: false,
              onGenerateRoute: RouteGenerator.generateRoute,
              initialRoute: Routes.landing),
        ),
      ),
    );
  }
}
