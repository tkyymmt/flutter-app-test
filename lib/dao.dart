import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile {
  final String name;
  final String email;
  UserProfile({required this.name, required this.email});
}

class UserDAO {
  Future<UserProfile> getCurrentUser() async {
    dynamic docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    UserProfile userProf = UserProfile(
        name: docSnapshot?.get('name'), email: docSnapshot?.get('email'));
    return userProf;
  }

  void updateCurrentUser(String name, String email) async {
    dynamic docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    docSnapshot?.update(name: name);
    docSnapshot?.update(email: email);
  }
}
