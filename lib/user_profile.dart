import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/dao.dart';

/*
final userProvider = FutureProvider.autoDispose(
    (ref) async => await ref.read(userDAOProvider).fetchUser());
final userProfileProvider = StateProvider.autoDispose((ref) {
  final userRef = ref.watch(userProvider);
  return userRef.maybeWhen(data: (data) => data, orElse: (() => null));
});
*/

final userProfileProvider =
    FutureProvider.autoDispose((ref) => ref.read(userDAOProvider).fetchUser());

final userNameProvider = StateProvider.autoDispose((ref) {
  final userProf = ref.watch(userProfileProvider);
  return userProf.maybeWhen(data: (data) => data!.name, orElse: (() => null));
});
final userEmailProvider = StateProvider.autoDispose((ref) {
  final userProf = ref.watch(userProfileProvider);
  return userProf.maybeWhen(data: (data) => data!.email, orElse: (() => null));
});
final userImageProvider = StateProvider.autoDispose((ref) {
  final userProf = ref.watch(userProfileProvider);
  return userProf.maybeWhen(data: (data) => data!.img, orElse: (() => null));
});
final userAuthProvider = Provider.autoDispose((ref) async {
  final userProf = await ref.watch(userProfileProvider.future);
  return userProf!.auth;
});

final userIdProvider = Provider.autoDispose((ref) {
  final userProf = ref.watch(userProfileProvider);
  return userProf.maybeWhen(data: (data) => data!.uid, orElse: (() => null));
});
final userVisitCountProvider = StateProvider.autoDispose((ref) {
  final userProf = ref.watch(userProfileProvider);
  return userProf.maybeWhen(
      data: (data) => data!.visitCount, orElse: (() => null));
});

// DO NOT CHANGE THE ORDER OF PROPERTY
enum Authority {
  admin,
  user,
}

class UserProfile {
  String _name;
  final String _email;
  final Image _img;
  final Authority _auth;
  final String _uid;
  int _visitCount;

  UserProfile(this._name, this._email, this._img, this._auth, this._uid,
      this._visitCount);

  String get name => _name;
  set name(String name) {
    if (name.isEmpty) throw Exception('name is empty');
    _name = name;
  }

  set visitCount(int count) {
    if (count < 0) throw 'visitCount was set by invalid number';
    _visitCount = count;
  }

  String get email => _email;
  Image get img => _img;
  Authority get auth => _auth;
  String get uid => _uid;
  int get visitCount => _visitCount;
}
