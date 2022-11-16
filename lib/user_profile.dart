// バリデーションをどこで行うか。コンストラクタかセッターなのかゲッターなのか

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/dao.dart';

final userProvider =
    FutureProvider((ref) async => await ref.read(userDAOProvider).fetchUser());

final userProfileProvider = StateProvider(((ref) {
  return ref
      .watch(userProvider)
      .maybeWhen(data: ((data) => data), orElse: () => null);
}));

/*
final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile>(
  () {
    print('AsyncNotifierProvider');
    return UserProfileNotifier();
  },
);

class UserProfileNotifier extends AsyncNotifier<UserProfile> {
  bool firstBuild = true;
  @override
  FutureOr<UserProfile> build() {
    if (firstBuild) {
      firstBuild = false;
      return UserDAO().fetchUser();
    }
  }

  updateName(String name) {
    this.update((data) => null);
    //UserDAO().updateCurrentUserName(name);
  }

  updateEmail(String email) {
    state.email = email;
    //UserDAO().updateCurrentUserEmail(email);
  }
}
*/

class UserProfile {
  String _name;
  String _email;

  UserProfile(this._name, this._email);

  String get name => _name;
  set name(String name) {
    if (name.isEmpty) throw Exception('name is empty');
    _name = name;
  }

  String get email => _email;
  set email(String email) {
    if (email.isEmpty) throw Exception('email is empty');
    _email = email;
  }
}
