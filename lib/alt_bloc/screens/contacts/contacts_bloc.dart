import 'package:bloc_common_state_issue/alt_bloc/base_bloc.dart';
import 'package:bloc_common_state_issue/alt_bloc/screens/connection_bloc.dart';
import 'package:bloc_common_state_issue/data/repository.dart';

class ContactsBloc extends BaseBloc implements ConnectionBloc {
  ContactsBloc(Repository repository, this._connectionBloc) : super(repository) {
    registerState<List<Contact>>(initialState: <Contact>[]);
    addNavigationSource(_connectionBloc.navigationStream);
    getContacts();
  }

  final ConnectionBloc _connectionBloc;

  Future<void> getContacts() async {
    showProgress();
    addFutureSource<List<Contact>>(repository.fetchContacts(),
        onDone: () => hideProgress(),
        onError: (e) => handleError(e));
  }

  void showDetails(Contact contact) {
    addNavigation(arguments: ContactDetailsState(contact, repository));
  }

  @override
  Future startCall(Contact contact) => _connectionBloc.startCall(contact);

  @override
  Future startChat(Contact contact) => _connectionBloc.startChat(contact);
}

class ContactDetailsState {

  ContactDetailsState(this.contact, this.repository);

  final Contact contact;
  final Repository repository;
}
