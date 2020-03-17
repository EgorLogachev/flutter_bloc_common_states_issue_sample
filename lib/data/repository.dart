import 'dart:math';

import 'package:bloc_common_state_issue/errors/errors.dart';

const names = [
  'Olivia',
  'Ava',
  'Isabella',
  'Sophia',
  'Charlotte',
  'Mia',
  'Amelia',
  'Harper',
  'Evelyn',
  'Abigail',
  'Emily',
  'Elizabeth',
  'Mila',
  'Ella',
  'Avery',
  'Sofia',
  'Camila',
  'Aria',
  'Scarlett',
  'Victoria',
  'Madison',
  'Luna',
  'Grace',
  'Chloe',
  'Penelope',
  'Layla',
  'Riley' 'Zoey',
  'Nora',
  'Lily',
  'Eleanor',
  'Hannah',
  'Lillian',
  'Addison',
  'Aubrey',
  'Ellie',
  'Stella',
  'Natalie',
  'Zoe'
];

class Repository {
  Future<String> signIn(String email, String password) {
    return _generateResult<String>([
      _ResultItem("success", weight: 3),
//      _ResultItem(ConnectionError()),
//      _ResultItem(BadCredentialsError()),
//      _ResultItem(UnexpectedError())
    ]);
  }

  Future<List<Contact>> fetchContacts() {
    final mixedNames = List.of(names);
    mixedNames.shuffle();
    return _generateResult<List<Contact>>([
      _ResultItem(List.generate(mixedNames.length, (index) => Contact(mixedNames[index])), weight: 2),
//      _ResultItem(ConnectionError()),
//      _ResultItem(UnexpectedError())
    ]);
  }

  Future<int> fetchSession() {
    return _generateResult<int>([
      _ResultItem(Random().nextInt(100), weight: 2),
      _ResultItem(UnauthorizedError(), weight: 2),
//      _ResultItem(ConnectionError()),
//      _ResultItem(UnexpectedError())
    ]);
  }

  Future<T> _generateResult<T>(List<_ResultItem> results, {Duration delay = const Duration(milliseconds: 500)}) {
    final result = _RandomResult(results).next();
    return Future.delayed(delay, () => result is Error ? throw result : result);
  }
}

class _RandomResult {
  const _RandomResult(this.items);

  final List<_ResultItem> items;

  dynamic next() {
    var weightsSum = 0;
    items.forEach((item) => weightsSum += item.weight);
    var randomWeight = Random().nextInt(weightsSum);
    for (var item in items) {
      randomWeight -= item.weight;
      if (randomWeight < 0) {
        return item.value;
      }
    }
    return null;
  }
}

class _ResultItem {
  const _ResultItem(this.value, {this.weight = 1});

  final dynamic value;
  final int weight;
}

class Contact {
  Contact(this.name);

  final String name;
}
