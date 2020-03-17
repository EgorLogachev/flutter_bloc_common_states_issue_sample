import 'package:bloc_common_state_issue/data/repository.dart';
import 'package:bloc_common_state_issue/errors/errors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common_states.dart';

abstract class BaseBloc<Event, State> extends Bloc<Event, State> with _CommonErrorsHandler<Event, State> {

  BaseBloc(this.repository);
  
  final Repository repository;

}

mixin _CommonErrorsHandler<Event, State> on Bloc<Event, State> {
  
  Repository get repository;

  State mapErrorToState(Error error) {
    if (error is ConnectionError) {
      return ConnectionErrorState() as State;
    } else if (error is UnauthorizedError) {
      return UnauthorizedErrorState(repository) as State;
    } else {
      return UnexpectedErrorState() as State;
    }
  }
}