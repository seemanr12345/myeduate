import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:myeduate/common/app/app.dart';
import 'package:myeduate/common/bloc/bloc_delegate.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ignore: deprecated_member_use
  BlocOverrides.runZoned(
    () {},
    blocObserver: BlocDelegate(),
  );

  runZoned(
    () async {
      runApp(const App());
    },
  );
}
