import 'package:bloc_common_state_issue/data/repository.dart';
import 'package:bloc_common_state_issue/flutter_bloc/screens/auth/auth_bloc.dart';
import 'package:bloc_common_state_issue/flutter_bloc/screens/contact_details/contact_details_bloc.dart';
import 'package:bloc_common_state_issue/flutter_bloc/screens/contacts/contacts_bloc.dart';

class ConnectionErrorState with AuthState, ContactsState, ContactDetailsState {}

class UnauthorizedErrorState with ContactsState, ContactDetailsState {
  UnauthorizedErrorState(this.repository, {this.extraData});

  final Repository repository;
  final extraData;
}

class UnexpectedErrorState with AuthState, ContactsState, ContactDetailsState {}

class ProgressState with AuthState, ContactsState, ContactDetailsState {}
