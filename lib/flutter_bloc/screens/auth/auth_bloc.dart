import 'package:bloc_common_state_issue/data/repository.dart';

import '../../base_bloc.dart';
import '../../common_states.dart';

class AuthBloc extends BaseBloc<AuthEvent, AuthState> {

  AuthBloc(Repository repository, {this.extraData}) : super(repository);

  final extraData;

  @override
  AuthState get initialState => AuthState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignInEvent) {
      yield* _signIn(event);
    } else if (event is CloseEvent) {
      yield CloseState();
    }
  }

  Stream<AuthState> _signIn(SignInEvent event) async* {
    yield ProgressState();
    try {
      await repository.signIn(event.email, event.password);
      yield extraData == null ? AuthorizedState(repository) : AuthorizedWithCompletionState(extraData);
    } catch (e) {
      yield mapErrorToState(e);
    }
  }

  void signIn(String email, String password) => add(SignInEvent(email, password));

  void closeScreen() => add(CloseEvent());
}

class AuthEvent {}

class SignInEvent extends AuthEvent {
  SignInEvent(this.email, this.password);

  final String email;
  final String password;

}

class CloseEvent extends AuthEvent {}

class AuthState {}

class AuthorizedState extends AuthState {
  AuthorizedState(this.repository);

  final Repository repository;
}

class AuthorizedWithCompletionState extends AuthState {
  AuthorizedWithCompletionState(this.extraData);

  final extraData;
}

class BadCredentialsState extends AuthState {}

class CloseState extends AuthState {}