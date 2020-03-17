import 'package:bloc_common_state_issue/data/repository.dart';
import 'package:bloc_common_state_issue/flutter_bloc/common_states.dart';
import 'package:bloc_common_state_issue/flutter_bloc/screens/auth/auth_screen.dart';
import 'package:bloc_common_state_issue/flutter_bloc/screens/connection_bloc.dart';
import 'package:bloc_common_state_issue/flutter_bloc/screens/contact_details/contact_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../connection_router.dart';
import 'contacts_bloc.dart';


class ContactsScreen extends StatelessWidget {
  ContactsScreen._(this._repository);

  static Route route(Repository repository) => MaterialPageRoute(builder: (_) => ContactsScreen._(repository));

  final Repository _repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactsBloc>(
      create: (_) => ContactsBloc(_repository),
      child: BlocListener<ContactsBloc, ContactsState>(
        listener: ContactsRouter().onRoute,
        child: _ContactsLayout(),
      ),
    );
  }
}

class _ContactsLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Contacts'),
        ),
        body: Stack(
          children: <Widget>[
            BlocBuilder<ContactsBloc, ContactsState>(
              condition: (_, current) => current is ContactsListState,
              builder: (_, contactsState) {
                final ContactsListState state = contactsState;
                final contacts = state.contacts;
                return RefreshIndicator(
                    onRefresh: () => BlocProvider.of<ContactsBloc>(context).fetchContacts(),
                    child: ListView.separated(
                      itemBuilder: (_, index) {
                        final contact = contacts[index];
                        return GestureDetector(
                          onTap: () {
                            BlocProvider.of<ContactsBloc>(context).showDetails(contact);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    contact.name,
                                    style: Theme.of(context).textTheme.display2,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Ink(
                                  child: IconButton(
                                      icon: Icon(Icons.call),
                                      color: Colors.white,
                                      onPressed: () => BlocProvider.of<ContactsBloc>(context).startCall(contact)),
                                  decoration: const ShapeDecoration(shape: CircleBorder(), color: Colors.black),
                                ),
                                SizedBox(
                                  width: 24.0,
                                ),
                                Ink(
                                  child: IconButton(
                                      icon: Icon(Icons.chat),
                                      color: Colors.white,
                                      onPressed: () => BlocProvider.of<ContactsBloc>(context).startChat(contact)),
                                  decoration: const ShapeDecoration(shape: CircleBorder(), color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => Divider(),
                      itemCount: contacts.length,
                    ));
              },
            ),
            BlocBuilder<ContactsBloc, ContactsState>(
              builder: (_, state) {
                return state is ProgressState ? Center(child: CircularProgressIndicator(),) : Container();
              },
            )
          ],
        ));
  }
}

class ContactsRouter extends ConnectionRouter<ContactsState> {
  @override
  void onRoute(BuildContext context, ContactsState state) async {
    if (state is ShowContactDetailsState) {
      Navigator.of(context).push(ContactDetailsScreen.route(state.repository, state.contact));
    } else if (state is UnauthorizedChatErrorState) {
      final result = await Navigator.of(context).push(AuthScreen.route(state.repository, extraData: state.extraData));
      BlocProvider.of<ContactsBloc>(context).startChat(result);
    } else if (state is UnauthorizedCallErrorState) {
      final result = await Navigator.of(context).push(AuthScreen.route(state.repository, extraData: state.extraData));
      BlocProvider.of<ContactsBloc>(context).startCall(result);
    } else {
      super.onRoute(context, state);
    }
  }
}
