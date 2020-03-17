import 'package:bloc_common_state_issue/alt_bloc/base_bloc.dart';
import 'package:bloc_common_state_issue/alt_bloc/screens/connection_bloc.dart';
import 'package:bloc_common_state_issue/data/repository.dart';

class ContactsBloc extends BaseBloc with ConnectionBloc {
  ContactsBloc(Repository repository) : super(repository) {
    registerState<List<Contact>>(initialState: <Contact>[]);
    getContacts();
  }

  Future<void> getContacts() async {
    showProgress();
    addFutureSource<List<Contact>>(repository.fetchContacts(),
        onDone: () => hideProgress(),
        onError: (e) => handleError(e));
  }

  void showDetails(Contact contact) {
    addNavigation(arguments: ContactDetailsState(contact, repository));
  }
}

class ContactDetailsState {

  ContactDetailsState(this.contact, this.repository);

  final Contact contact;
  final Repository repository;
}
