import 'package:bloc_common_state_issue/data/repository.dart';

class ConnectionErrorState {}

class UnauthorizedErrorState {
  UnauthorizedErrorState(this.repository, {this.extraData});

  final Repository repository;
  final extraData;
}

class UnexpectedErrorState {}
