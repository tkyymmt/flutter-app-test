import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/user_profile.dart';

class UserDAO {
  Future<UserProfile?> fetchUser() async {
    try {
      dynamic docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      String name = docRef?.get('name');
      String email = docRef?.get('email');
      return UserProfile(name, email);
    } catch (e) {
      // do something with [e]
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
      return e.code;
    }
  }
}
