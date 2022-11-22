// バリデーションをどこで行うか。コンストラクタかセッターなのかゲッターなのか

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/dao.dart';

final userProvider = FutureProvider.autoDispose(
    (ref) async => await ref.read(userDAOProvider).fetchUser());

final userProfileProvider = StateProvider.autoDispose((ref) {
  return ref
      .watch(userProvider)
      .maybeWhen(data: ((data) => data), orElse: () => null);
});
final profImgProvider = FutureProvider.autoDispose((ref) async {
  final url = await UserDAO.getProfImgURL();
  return Image.network(url);
});
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
  String _imgURL;

  UserProfile(this._name, this._email, this._imgURL);

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

  String get imgURL => _imgURL;
  set imgURL(String imgURL) {
    if (imgURL.isEmpty) throw Exception('imgURL is empty');
    _imgURL = imgURL;
  }
}
