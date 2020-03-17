import 'package:bloc_common_state_issue/data/repository.dart';
import 'package:bloc_common_state_issue/errors/errors.dart';

import '../../base_bloc.dart';

class AuthBloc extends BaseBloc {
  AuthBloc(Repository repository, {this.extraData}) : super(repository) {
    registerState<BadCredentialsState>();
  }

  final extraData;

  Future signIn(String email, String password) async {
    addState<BadCredentialsState>(null);
    try {
      showProgress();
      await repository.signIn(email, password);
      addNavigation(arguments: extraData == null
          ? AuthorizedState(repository)
          : AuthorizedWithCompletionState(extraData));
    } catch (e) {
      handleError(e);
    } finally {
      hideProgress();
    }
  }

  @override
  void handleError(Error error) {
    if (error is BadCredentialsError) {
      addState<BadCredentialsState>(BadCredentialsState());
    } else {
      super.handleError(error);
    }
  }

  void close() {
    addNavigation(arguments: CloseState());
  }
}

class AuthorizedState {
  AuthorizedState(this.repository);

  final Repository repository;
}

class AuthorizedWithCompletionState {
  AuthorizedWithCompletionState(this.extraData);

  final extraData;
}

class BadCredentialsState {}

class CloseState {}
