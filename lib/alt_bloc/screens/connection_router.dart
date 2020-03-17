import 'package:bloc_common_state_issue/alt_bloc/common_states.dart';
import 'package:flutter/widgets.dart';
import '../common_router.dart';
import 'connection/connection_screen.dart';
import 'connection_bloc.dart';

class ConnectionRouter extends ScreenRouter {
  @override
  Future<T> onRoute<T>(BuildContext context, String name, dynamic args) {
    if (args is CallConnectionState) {
      return Navigator.of(context).push(CallConnectionScreen.route(args.contact));
    } else if (args is ChatConnectionState) {
      return Navigator.of(context).push(ChatConnectionScreen.route(args.contact));
    } else {
      return super.onRoute(context, name, args);
    }
  }
}