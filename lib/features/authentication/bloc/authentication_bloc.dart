import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myeduate/features/authentication/resource/user_repository.dart';
// import 'package:shared_preferences/shared_preferences.dart';
part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({required this.userRepository})
      : super(AuthenticationUninitialized()) {
    on<AuthenticationEvent>((event, emit) async {
      // var uid = userRepository.firebaseAuth.currentUser?.uid; c
      if (event is AuthStarted) {
        if (userRepository.currentUser()) {
          emit(AuthenticationSuccess());
        } else {
          emit(AuthenticationUnauthenticated());
        }
      }

      if (event is LoggedOut) {
        emit(AuthenticationUnauthenticated());
      }
    });
  }
}
