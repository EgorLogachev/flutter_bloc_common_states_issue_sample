import 'package:bloc_common_state_issue/alt_bloc/screens/auth/auth_screen.dart';
import 'package:bloc_common_state_issue/data/repository.dart';
import 'package:flutter/material.dart';


void main() => runApp(AltBlocApp());

final Repository _repository = Repository();

class AltBlocApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthScreen(_repository),
    );
  }
}

bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  return inDebugMode;
}
