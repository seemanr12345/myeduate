part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthenticationEvent {}

class OnboardingFinished extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String? uid;

  const LoggedIn({required this.uid});

  @override
  List<Object?> get props => [uid];

  @override
  String toString() => 'LoggedIn { uid: $uid }';
}

class LoggedOut extends AuthenticationEvent {}
