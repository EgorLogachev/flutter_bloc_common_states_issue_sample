import 'package:bloc_common_state_issue/alt_bloc/common_states.dart';
import 'package:bloc_common_state_issue/alt_bloc/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'main.dart';

class ScreenRouter = BaseRouter with _CommonErrorsRouter;

mixin _CommonErrorsRouter implements BaseRouter {

  @override
  Future<T> onRoute<T>(BuildContext context, String name, dynamic args) {
    if (args is ConnectionErrorState) {
      return showConnectionErrorDialog(context);
    } else if (args is UnauthorizedErrorState) {
      return Navigator.of(context).push(AuthScreen.route(args.repository, extraData: args.extraData));
    } else if (args is UnexpectedErrorState) {
      return showUnexpectedErrorDialog(context);
    } else {
      if (isInDebugMode) {
        throw FlutterError('Handler for route with name: $name and arguments: $args wasn\'t defined in app');
      }
      return null;
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

abstract class BaseRouter {
  Future<T> onRoute<T>(BuildContext context, String name, dynamic args);
}