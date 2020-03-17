import 'package:alt_bloc/alt_bloc.dart';
import 'package:bloc_common_state_issue/alt_bloc/common_states.dart';
import 'package:bloc_common_state_issue/data/repository.dart';
import 'package:bloc_common_state_issue/errors/errors.dart';

class BaseBloc extends Bloc with _CommonErrorsHandler {

  BaseBloc(this.repository) {
    registerState<bool>(initialState: false);
  }

  void showProgress() => addState<bool>(true);

  void hideProgress() => addState<bool>(false);
  
  final Repository repository;

}

mixin _CommonErrorsHandler on Bloc {
  
  Repository get repository;

  void handleError(Error error) {
    if (error is ConnectionError) {
      addNavigation(arguments: ConnectionErrorState());
    } else if (error is UnauthorizedError) {
      addNavigation(arguments: UnauthorizedErrorState(repository));
    } else {
      addNavigation(arguments: UnexpectedErrorState());
    }
  }
}