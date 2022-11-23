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

class UserProfile {
  String _name;
  final String _email;
  final Image _img;

  UserProfile(this._name, this._email, this._img);

  String get name => _name;
  set name(String name) {
    if (name.isEmpty) throw Exception('name is empty');
    _name = name;
  }

  String get email => _email;
  Image get img => _img;
}
