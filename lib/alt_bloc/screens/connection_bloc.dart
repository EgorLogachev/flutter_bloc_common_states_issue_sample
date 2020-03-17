import 'package:bloc_common_state_issue/alt_bloc/base_bloc.dart';
import 'package:bloc_common_state_issue/alt_bloc/common_states.dart';
import 'package:bloc_common_state_issue/data/repository.dart';
import 'package:bloc_common_state_issue/errors/errors.dart';

mixin ConnectionBloc on BaseBloc {

  Future startCall(Contact contact) async {
    return _startConnection(contact, (sessionId, contact) => CallConnectionState(sessionId, contact));
  }

  Future startChat(Contact contact) async {
    return _startConnection(contact, (sessionId, contact) => ChatConnectionState(sessionId, contact));
  }

  Future _startConnection(Contact contact, ConnectionState Function(int, Contact) stateCreator) async {
    try {
      showProgress();
      int sessionId = await repository.fetchSession();
      addNavigation(arguments: stateCreator(sessionId, contact));
    } catch (e) {
      if (e is UnauthorizedError) {
        final result = await addNavigation(arguments: UnauthorizedErrorState(repository, extraData: contact));
        _startConnection(result, stateCreator);
      } else {
        handleError(e);
      }
    } finally {
      hideProgress();
    }
  }
}

class ConnectionState {
  ConnectionState(this.sessionId, this.contact);

  final int sessionId;
  final Contact contact;
}

class ChatConnectionState extends ConnectionState {
  ChatConnectionState(int sessionId, Contact contact) : super(sessionId, contact);
}

class CallConnectionState extends ConnectionState {
  CallConnectionState(int sessionId, Contact contact) : super(sessionId, contact);
}