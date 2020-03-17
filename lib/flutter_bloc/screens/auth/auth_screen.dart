import 'package:bloc_common_state_issue/data/repository.dart';
import 'package:bloc_common_state_issue/flutter_bloc/common_states.dart';
import 'package:bloc_common_state_issue/flutter_bloc/screens/contacts/contacts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_router.dart';
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
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(_repo, extraData: extraData),
      child: BlocListener<AuthBloc, AuthState>(
          listener: _AuthRouter().onRoute,
          child: _AuthLayout()),
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
              BlocProvider.of<AuthBloc>(context).closeScreen();
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
                  BlocBuilder<AuthBloc, AuthState>(
                      builder: (_, state) {
                        return state is BadCredentialsState
                            ? Text(
                          'You have entered an invalid email or password',
                          style: Theme.of(context).textTheme.body1.copyWith(color: Colors.redAccent),
                        )
                            : Container();
                      }),
                  SizedBox(
                    height: 8.0,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (_, state) {
                          return RaisedButton(
                              child: state is ProgressState
                                  ? SizedBox(
                                      child: CircularProgressIndicator(),
                                      width: 24.0,
                                      height: 24.0,
                                    )
                                  : Text('Sign In'),
                              onPressed: () {
                                BlocProvider.of<AuthBloc>(context)
                                    .signIn(_emailController.text, _passwordController.text);
                              });
                        },
                      ))
                ],
              ),
            )));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class _AuthRouter extends ScreenRouter<AuthState> {
  @override
  void onRoute(BuildContext context, AuthState state) {
    if (state is AuthorizedState) {
      Navigator.of(context).pushReplacement(ContactsScreen.route(state.repository));
    } else if (state is AuthorizedWithCompletionState) {
      Navigator.of(context).pop(state.extraData);
      return null;
    } else if (state is CloseState) {
      SystemNavigator.pop();
    } else {
      super.onRoute(context, state);
    }
  }
}
