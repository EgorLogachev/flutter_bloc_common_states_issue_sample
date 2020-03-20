import 'package:alt_bloc/alt_bloc.dart';
import 'package:bloc_common_state_issue/alt_bloc/screens/connection_bloc.dart';
import 'package:bloc_common_state_issue/alt_bloc/screens/connection_router.dart';
import 'package:bloc_common_state_issue/alt_bloc/screens/contact_details/contact_details_screen.dart';
import 'package:bloc_common_state_issue/alt_bloc/screens/contacts/contacts_bloc.dart';
import 'package:bloc_common_state_issue/data/repository.dart';
import 'package:flutter/material.dart';


class ContactsScreen extends StatelessWidget {
  ContactsScreen._(this._repository);

  static Route route(Repository repository) => MaterialPageRoute(builder: (_) => ContactsScreen._(repository));

  final Repository _repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactsBloc>(
      child: _ContactsLayout(),
      create: () => ContactsBloc(_repository, ConnectionBloc(_repository)),
      router: ContactsRouter().onRoute,
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
            BlocBuilder<ContactsBloc, List<Contact>>(
              builder: (_, contacts) {
                return RefreshIndicator(
                    onRefresh: () => Provider.of<ContactsBloc>(context).getContacts(),
                    child: ListView.separated(
                      itemBuilder: (_, index) {
                        final contact = contacts[index];
                        return GestureDetector(
                          onTap: () {
                            Provider.of<ContactsBloc>(context).showDetails(contact);
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
                                      onPressed: () => Provider.of<ContactsBloc>(context).startCall(contact)),
                                  decoration: const ShapeDecoration(shape: CircleBorder(), color: Colors.black),
                                ),
                                SizedBox(
                                  width: 24.0,
                                ),
                                Ink(
                                  child: IconButton(
                                      icon: Icon(Icons.chat),
                                      color: Colors.white,
                                      onPressed: () => Provider.of<ContactsBloc>(context).startChat(contact)),
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
            BlocBuilder<ContactsBloc, bool>(
              builder: (_, progress) {
                return progress ? Center(child: CircularProgressIndicator(),) : Container();
              },
            )
          ],
        ));
  }
}

class ContactsRouter extends ConnectionRouter {
  @override
  Future<T> onRoute<T>(BuildContext context, String name, dynamic args) {
    if (args is ContactDetailsState) {
      return Navigator.of(context).push(ContactDetailsScreen.route(args.repository, args.contact));
    } else {
      return super.onRoute(context, name, args);
    }
  }
}
