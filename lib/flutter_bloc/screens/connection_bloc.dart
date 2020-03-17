import 'package:bloc_common_state_issue/data/repository.dart';
import 'package:bloc_common_state_issue/errors/errors.dart';
import 'package:bloc_common_state_issue/flutter_bloc/screens/contact_details/contact_details_bloc.dart';
import 'package:bloc_common_state_issue/flutter_bloc/screens/contacts/contacts_bloc.dart';

import '../base_bloc.dart';
import '../common_states.dart';

enum ConnectionType {Chat, Call}

mixin ConnectionBloc<Event, State> on BaseBloc<Event, State> {
  void startChat(Contact contact) {
    add(ChatConnectionEvent(contact) as Event);
  }

  void startCall(Contact contact) {
    add(CallConnectionEvent(contact) as Event);
  }

  Stream<State> _startCall(Contact contact) async* {
    yield* _startConnection(contact, ConnectionType.Call);
  }

  Stream<State> _startChat(Contact contact) async* {
    yield* _startConnection(contact, ConnectionType.Chat);
  }

  Stream<State> _startConnection(Contact contact, ConnectionType type) async* {
    try {
      yield ProgressState() as State;
      int sessionId = await repository.fetchSession();
      if (type == ConnectionType.Call) {
        yield CallConnectionState(sessionId, contact) as State;
      } else if (type == ConnectionType.Chat) {
        yield ChatConnectionState(sessionId, contact) as State;
      }
    } catch (e) {
      if (e is UnauthorizedError) {
        if (type == ConnectionType.Call) {
          yield UnauthorizedCallErrorState(repository, extraData: contact) as State;
        } else if (type == ConnectionType.Chat) {
          yield UnauthorizedChatErrorState(repository, extraData: contact) as State;
        }
      } else {
        yield mapErrorToState(e);
      }
    }
  }

  @override
  Stream<State> mapEventToState(Event event) async* {
    if (event is ChatConnectionEvent) {
      yield* _startChat(event.contact);
    } else if (event is CallConnectionEvent) {
      yield* _startCall(event.contact);
    }
  }
}

class ConnectionEvent with ContactDetailsEvent, ContactsEvent {
  ConnectionEvent(this.contact);

  final Contact contact;
}

class ChatConnectionEvent extends ConnectionEvent {
  ChatConnectionEvent(Contact contact) : super(contact);
}

class CallConnectionEvent extends ConnectionEvent {
  CallConnectionEvent(Contact contact) : super(contact);
}

class ConnectionState with ContactsState, ContactDetailsState {}

class ChatConnectionState extends ConnectionState {
  ChatConnectionState(this.sessionId, this.contact);

  final int sessionId;
  final Contact contact;
}

class CallConnectionState extends ConnectionState {
  CallConnectionState(this.sessionId, this.contact);

  final int sessionId;
  final Contact contact;
}

class UnauthorizedCallErrorState extends UnauthorizedErrorState with ContactsState, ContactDetailsState {
  UnauthorizedCallErrorState(Repository repository, {extraData}) : super(repository, extraData: extraData);
}

class UnauthorizedChatErrorState extends UnauthorizedErrorState {
  UnauthorizedChatErrorState(Repository repository, {extraData}) : super(repository, extraData: extraData);
}
