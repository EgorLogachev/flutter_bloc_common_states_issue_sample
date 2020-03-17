import 'package:alt_bloc/alt_bloc.dart';
import 'package:bloc_common_state_issue/alt_bloc/common_router.dart';
import 'package:bloc_common_state_issue/alt_bloc/screens/contacts/contacts_screen.dart';
import 'package:bloc_common_state_issue/data/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'auth_bloc.dart';

class AuthScreen extends StatelessWidget {

  const AuthScreen(this._repo, {this.extraData});

  static route(Repository repository, {extraData}) => MaterialPageRoute(builder: (_) {
    return AuthScreen(repository, extraData: extraData);
  });

  final Repository _repo;
  final extraData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: _AuthLayout(),
      create: () => AuthBloc(_repo, extraData: extraData),
      router: _AuthRouter().onRoute,
    );
  }
}

class _AuthLayout extends StatefulWidget {
  _AuthLayout() : super();

  @override
  State<StatefulWidget> createState() => _AuthLayoutState();
}

class _AuthLayoutState extends State<_AuthLayout> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
        ),
        body: WillPopScope(
            onWillPop: () async {
              Provider.of<AuthBloc>(context).close();
              return false;
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 16.0,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email (Optional)'),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(hintText: 'Password (Optional)'),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  BlocBuilder<AuthBloc, BadCredentialsState>(builder: (_, state) {
                    return state == null
                        ? Container()
                        : Text(
                      'You have entered an invalid email or password',
                      style: Theme
                          .of(context)
                          .textTheme
                          .body1
                          .copyWith(color: Colors.redAccent),
                    );
                  }),
                  SizedBox(
                    height: 8.0,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<AuthBloc, bool>(
                        builder: (_, progress) {
                          return RaisedButton(
                              child: progress
                                  ? SizedBox(
                                child: CircularProgressIndicator(),
                                width: 24.0,
                                height: 24.0,
                              )
                                  : Text('Sign In'),
                              onPressed: () {
                                Provider.of<AuthBloc>(context).signIn(_emailController.text, _passwordController.text);
                              });
                        },
                      ))
                ],
              ),
            ))
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class _AuthRouter extends ScreenRouter {
  @override
  Future<T> onRoute<T>(BuildContext context, String name, dynamic args) {
    if (args is AuthorizedState) {
      return Navigator.of(context).pushReplacement(ContactsScreen.route(args.repository));
    } else if (args is AuthorizedWithCompletionState) {
      Navigator.of(context).pop(args.extraData);
      return null;
    } else if (args is CloseState) {
      SystemNavigator.pop();
      return null;
    } else {
      return super.onRoute<T>(context, name, args);
    }
  }
}
