import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'error_dispatcher.dart';

Future<String> signInUser(
    {required String email, required String password}) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return '';
  } on FirebaseAuthException catch (e) {
    return e.code;
  }
}

Future<String> signOutUser() async {
  try {
    await FirebaseAuth.instance.signOut();
    return '';
  } on FirebaseAuthException catch (e) {
    ErrorDispatcher.dispatch(e.code);
    return e.code;
  }
}
