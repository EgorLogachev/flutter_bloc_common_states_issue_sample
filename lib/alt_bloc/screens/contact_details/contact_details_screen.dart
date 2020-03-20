import 'package:alt_bloc/alt_bloc.dart';
import 'package:bloc_common_state_issue/alt_bloc/screens/connection_bloc.dart';
import 'package:bloc_common_state_issue/alt_bloc/screens/connection_router.dart';
import 'package:bloc_common_state_issue/data/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ContactDetailsScreen extends StatelessWidget {
  ContactDetailsScreen._(this._repository, this._contact);

  static Route route(Repository repository, Contact contact) =>
      MaterialPageRoute(builder: (_) => ContactDetailsScreen._(repository, contact));

  final Repository _repository;
  final Contact _contact;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: _ContactDetailsLayout(_contact),
      create: () => ConnectionBloc(_repository),
      router: ConnectionRouter().onRoute,
    );
  }
}

class _ContactDetailsLayout extends StatelessWidget {
  const _ContactDetailsLayout(this._contact);

  final Contact _contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Details'),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.black12,
                    backgroundImage: NetworkImage(
                        'https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/6713/girl-head-clipart-md.png'),
                    radius: 100.0,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    _contact.name,
                    style: Theme.of(context).textTheme.display1.copyWith(color: Colors.black87),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: Ink(
                          decoration: const ShapeDecoration(shape: CircleBorder(), color: Colors.black),
                          padding: EdgeInsets.all(8.0),
                          child: IconButton(
                              iconSize: 48.0,
                              icon: Icon(Icons.call),
                              color: Colors.white,
                              onPressed: () => Provider.of<ConnectionBloc>(context).startCall(_contact)),
                        )),
                        Expanded(
                          child: Ink(
                            decoration: const ShapeDecoration(shape: CircleBorder(), color: Colors.black),
                            padding: EdgeInsets.all(8.0),
                            child: IconButton(
                                iconSize: 48.0,
                                icon: Icon(Icons.chat),
                                color: Colors.white,
                                onPressed: () => Provider.of<ConnectionBloc>(context).startChat(_contact)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<ConnectionBloc, bool>(builder: (_, progress) {
              return progress ? Center(child: CircularProgressIndicator()) : Container();
            })
          ],
        ));
  }
}
