import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/error_dispatcher.dart';
import 'package:test/user_profile.dart';

final userDAOProvider = Provider((ref) => UserDAO());

class UserDAO {
  static Future<String> getProfImgURL() async {
    try {
      const String img = 'prof_img.png';
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      final String url = await FirebaseStorage.instance
          .ref()
          .child('users/$uid/$img')
          .getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      ErrorDispatcher.dispatch(e.code);
      rethrow;
    }
  }

  Future<UserProfile?> fetchUser() async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      String name = docRef.get('name');
      String email = docRef.get('email');

      final String imgURL = await getProfImgURL();

      return UserProfile(
        name,
        email,
        imgURL,
      );
    } on FirebaseException catch (e) {
      ErrorDispatcher.dispatch(e.code);
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
      ErrorDispatcher.dispatch(e.code);
      return e.code;
    }
  }
}
