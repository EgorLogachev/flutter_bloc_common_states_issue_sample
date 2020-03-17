import 'package:bloc_common_state_issue/data/repository.dart';
import 'package:bloc_common_state_issue/flutter_bloc/common_states.dart';
import 'package:bloc_common_state_issue/flutter_bloc/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../connection_bloc.dart';
import '../connection_router.dart';
import 'contact_details_bloc.dart';

class ContactDetailsScreen extends StatelessWidget {
  ContactDetailsScreen._(this._repository, this._contact);

  static Route route(Repository repository, Contact contact) =>
      MaterialPageRoute(builder: (_) => ContactDetailsScreen._(repository, contact));

  final Repository _repository;
  final Contact _contact;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ContactDetailsBloc(_repository),
        child: BlocListener<ContactDetailsBloc, ContactDetailsState>(
          listener: _ContactDetailsRouter().onRoute,
          child: _ContactDetailsLayout(_contact),
        )
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
                              onPressed: () => BlocProvider.of<ContactDetailsBloc>(context).startCall(_contact)),
                        )),
                        Expanded(
                          child: Ink(
                            decoration: const ShapeDecoration(shape: CircleBorder(), color: Colors.black),
                            padding: EdgeInsets.all(8.0),
                            child: IconButton(
                                iconSize: 48.0,
                                icon: Icon(Icons.chat),
                                color: Colors.white,
                                onPressed: () => BlocProvider.of<ContactDetailsBloc>(context).startChat(_contact)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<ContactDetailsBloc, ContactDetailsState>(builder: (_, state) {
              return state is ProgressState ? Center(child: CircularProgressIndicator()) : Container();
            })
          ],
        ));
  }
}

class _ContactDetailsRouter extends ConnectionRouter<ContactDetailsState> {
  @override
  void onRoute(BuildContext context, ContactDetailsState state) async {
    if (state is UnauthorizedChatErrorState) {
      final result = await Navigator.of(context).push(AuthScreen.route(state.repository, extraData: state.extraData));
      BlocProvider.of<ContactDetailsBloc>(context).startChat(result);
    } else if (state is UnauthorizedCallErrorState) {
      final result = await Navigator.of(context).push(AuthScreen.route(state.repository, extraData: state.extraData));
      BlocProvider.of<ContactDetailsBloc>(context).startCall(result);
    } else {
      super.onRoute(context, state);
    }
  }
}
