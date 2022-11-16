import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/error_dispatcher.dart';
import 'package:test/user_profile.dart';

final userDAOProvider = Provider((ref) => UserDAO());

class UserDAO {
  Future<UserProfile?> fetchUser() async {
    try {
      dynamic docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      String name = docRef.get('name');
      String email = docRef.get('email');

      return UserProfile(name, email);
    } catch (e) {
      //ErrorDispatcher.dispatch(e.toString());
      return null;
    }
  }

  Future<String> updateCurrentUserName(String name) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'name': name});
      return '';
    } on FirebaseException catch (e) {
      //ErrorDispatcher.dispatch(e.toString());
      return e.code;
    }
  }
}
