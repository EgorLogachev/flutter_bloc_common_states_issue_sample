import 'package:bloc_common_state_issue/data/repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../common_router.dart';
import '../common_states.dart';
import 'auth/auth_screen.dart';
import 'connection/connection_screen.dart';
import 'connection_bloc.dart';

class ConnectionRouter<State> extends ScreenRouter<State> {
  @override
  void onRoute(BuildContext context, State state) async {
    if (state is CallConnectionState) {
      Navigator.of(context).push(CallConnectionScreen.route(state.contact));
    } else if (state is ChatConnectionState) {
      Navigator.of(context).push(ChatConnectionScreen.route(state.contact));
    } else {
      super.onRoute(context, state);
    }
  }
}
