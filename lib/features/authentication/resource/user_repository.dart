import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:myeduate/common/routes/routes.dart';

class UserRepository {
  UserRepository({User? firebaseAuth}) : _firebaseAuth = firebaseAuth;
  User? _firebaseAuth;
  final firebaseAuth = FirebaseAuth.instance;


  bool currentUser() {
    //log.i('isUserLoggedIn called');
    _firebaseAuth = FirebaseAuth.instance.currentUser;
    return _firebaseAuth != null;
  }
  Future<void> signOut(context) async {
    Navigator.pushReplacementNamed(context, Routes.login);
    await firebaseAuth.signOut();
  }

}