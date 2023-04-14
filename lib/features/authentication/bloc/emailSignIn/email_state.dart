part of 'email_bloc.dart';

abstract class EmailAuthState extends Equatable {
  const EmailAuthState();
  @override
  List<Object> get props => [];
}

class EmailAuthInitial extends EmailAuthState {
  @override
  List<Object> get props => [];
}

class EmailStateLoading extends EmailAuthState {}
class EmailSignUpStateSuccess extends EmailAuthState {}

class EmailSignUpStateFailed extends EmailAuthState {
  final String error;
  const EmailSignUpStateFailed(this.error);

  @override
  List<Object> get props => [error];
}


class EmailStateSuccess extends EmailAuthState {}

class EmailStateFailed extends EmailAuthState{
  final String error;
  const EmailStateFailed(this.error);

  @override
  List<Object> get props => [error];
}