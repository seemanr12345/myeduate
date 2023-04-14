part of 'email_bloc.dart';

abstract class EmailAuthEvent extends Equatable {
  const EmailAuthEvent();
  @override
  List<Object> get props => [];
}

class LoginWithCredentials extends EmailAuthEvent {
  final String email;
  final String password;
  final BuildContext context;
  const LoginWithCredentials({required this.email,required this.context , required this.password});

  @override
  List<Object> get props => [];
}
class SignupEvent extends EmailAuthEvent {
  final String email;
  final String password;
  final String name;
  final BuildContext context;
  const SignupEvent({required this.email,required this.context , required this.password ,required this.name});

  @override
  List<Object> get props => [];
}
