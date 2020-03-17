import 'package:bloc_common_state_issue/data/repository.dart';

import '../../base_bloc.dart';
import '../../common_states.dart';
import '../connection_bloc.dart';

class ContactsBloc extends BaseBloc<ContactsEvent, ContactsState> with ConnectionBloc<ContactsEvent, ContactsState> {

  ContactsBloc(Repository repository) : super(repository) {
    fetchContacts();
  }
  
  @override
  ContactsState get initialState => ContactsListState.empty();

  @override
  Stream<ContactsState> mapEventToState(ContactsEvent event) async* {
    if (event is FetchContactsEvent) {
      yield* _fetchContacts();
    } else if (event is ShowContactDetailsEvent) {
      yield ShowContactDetailsState(event.contact, repository);
    } else {
      yield* super.mapEventToState(event);
    }
  }
  
  Future<void> fetchContacts() async => add(FetchContactsEvent());
  
  void showDetails(Contact contact) => add(ShowContactDetailsEvent(contact));
  
  Stream<ContactsState> _fetchContacts() async* {
    try {
      yield ProgressState();
      final result = await repository.fetchContacts();
      yield ContactsListState(result);  
    } catch(e) {
      yield mapErrorToState(e);
    }
  }
}

class ContactsEvent {}

class FetchContactsEvent extends ContactsEvent {}

class ShowContactDetailsEvent extends ContactsEvent {
  ShowContactDetailsEvent(this.contact);
  final Contact contact;
}

class ContactsState {}

class ShowContactDetailsState extends ContactsState {

  ShowContactDetailsState(this.contact, this.repository);

  final Contact contact;
  final Repository repository;
}

class ContactsListState extends ContactsState {

  ContactsListState(this.contacts);
  
  factory ContactsListState.empty() => ContactsListState(<Contact>[]);  
  
  final List<Contact> contacts;
  
}
