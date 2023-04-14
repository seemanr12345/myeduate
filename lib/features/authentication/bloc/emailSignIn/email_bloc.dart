
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myeduate/common/routes/routes.dart';
import 'package:myeduate/common/utility/Apputilities.dart';
import 'package:myeduate/features/authentication/resource/user_repository.dart';
import 'package:myeduate/features/dashboard/dashboard_ui.dart';
//import 'package:logger/logger.dart';

part 'email_event.dart';
part 'email_state.dart';


class EmailAuthBloc extends Bloc<EmailAuthEvent, EmailAuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  BuildContext context;
  EmailAuthBloc({required this.context}): super(EmailAuthInitial()) {
    on<EmailAuthEvent>((event, emit) {
      if(event is LoginWithCredentials){
        emit(EmailStateLoading());
        verifyEmail(event.email, event.password, event.context);
      }
      else if(event is SignupEvent){
        emit(EmailStateLoading());
      }


    });
  }


  verifyEmail(String mail , String password,BuildContext ctx) async{
    try {
      var userCredential = await _auth
          .signInWithEmailAndPassword(email: mail, password: password);
      if (userCredential.user != null) {
        var user = userCredential.user;
        UserRepository(firebaseAuth: user);
        emit(EmailStateSuccess());
          dynamic uid=await _auth.currentUser!.getIdToken();
          print("hi $uid");
          UserDetails(uid);
          print(UserDetails);
          print("hello");
         // Navigator.push(context, MaterialPageRoute(builder: (context)=> DashBoard()));
         // Navigator.pushNamed(context, Routes.dashboard, arguments: {'uid':uid});
          await Navigator.of(ctx)
              .pushNamedAndRemoveUntil(Routes.dashboard,

                  (Route<dynamic> route) => false);

      }
    } on FirebaseException catch (e) {
      emit(EmailStateFailed(e.message ?? "Incorrect Creds"));
    }
  }
}