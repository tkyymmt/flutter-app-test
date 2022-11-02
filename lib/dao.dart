import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDAO {
  _UserProfile userProf = _UserProfile('', '');

  Future<String> fetchUser() async {
    try {
      dynamic docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      userProf = _UserProfile(docRef?.get('name'), docRef?.get('email'));
      return '';
    } on FirebaseException catch (e) {
      return e.code;
    }
  }

  Future<String> updateCurrentUserName(String name) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'name': name});
      userProf.name = name;
      return '';
    } on FirebaseException catch (e) {
      return e.code;
    }
  }
}

class _UserProfile {
  String _name;
  String _email;

  _UserProfile(this._name, this._email);

  String get name => _name;
  set name(String name) {
    _name = name;
  }

  String get email => _email;
  set email(String email) {
    _email = email;
  }
}
