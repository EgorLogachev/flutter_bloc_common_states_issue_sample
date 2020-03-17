import 'package:bloc_common_state_issue/data/repository.dart';

import '../../base_bloc.dart';
import '../connection_bloc.dart';

class ContactDetailsBloc extends BaseBloc<ContactDetailsEvent, ContactDetailsState>
    with ConnectionBloc<ContactDetailsEvent, ContactDetailsState> {
  ContactDetailsBloc(Repository repository) : super(repository);

  @override
  ContactDetailsState get initialState => ContactDetailsState();

  @override
  Stream<ContactDetailsState> mapEventToState(ContactDetailsEvent event) async* {
    yield* super.mapEventToState(event);
  }
}

class ContactDetailsEvent {}

class ContactDetailsState {}
