import 'package:bloc_common_state_issue/flutter_bloc/common_states.dart';
import 'package:bloc_common_state_issue/flutter_bloc/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class ScreenRouter<State> = BaseRouter<State> with _CommonErrorsRouter<State>;

mixin _CommonErrorsRouter<State> implements BaseRouter<State> {

  @override
  void onRoute(BuildContext context, State state) {
    if (state is ConnectionErrorState) {
      showConnectionErrorDialog(context);
    } else if (state is UnauthorizedErrorState) {
      Navigator.of(context).push(AuthScreen.route(state.repository, extraData: state.extraData));
    } else if (state is UnexpectedErrorState) {
      showUnexpectedErrorDialog(context);
    }
  }

  Future showConnectionErrorDialog(BuildContext context) {
    return showDialog(context: context, builder: (_) {
      return AlertDialog(
        title: Text('No internet connection.'),
        content: Text('Probably some issues with your internet connection. Please, check and try again.'),
      );
    });
  }

  Future showUnexpectedErrorDialog(BuildContext context) {
    return showDialog(context: context, builder: (_) {
      return AlertDialog(
        title: Text('Oops!'),
        content: Text('Sorry for that, but something went wrong. We\'re working on it.'),
      );
    });
  }
}

abstract class BaseRouter<State> {
  void onRoute(BuildContext context, State state);
}