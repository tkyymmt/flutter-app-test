import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/error_dispatcher.dart';
import 'package:test/user_profile.dart';

final userDAOProvider = Provider((ref) => UserDAO());

class UserDAO {
  Future<String> _getProfImgURL(String uid) async {
    try {
      const String img = 'prof_img.png';
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
      Authority auth = Authority.values[docRef.get('auth')];
      String uid = FirebaseAuth.instance.currentUser!.uid;
      int visitCount = docRef.get('visitCount');

      final String imgURL =
          await _getProfImgURL(FirebaseAuth.instance.currentUser!.uid);
      final Image img = Image.network(imgURL);

      return UserProfile(
        name,
        email,
        img,
        auth,
        uid,
        visitCount,
      );
    } on FirebaseException catch (e) {
      ErrorDispatcher.dispatch(e.code);
      return null;
    }
  }

  Future<List<UserProfile>?> fetchUsers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      List<UserProfile> userProfs = [];
      for (final doc in snapshot.docs) {
        final url = await _getProfImgURL(doc.id);
        final img = Image.network(url);
        final auth = Authority.values[doc.get('auth')];
        UserProfile userProf = UserProfile(doc.get('name'), doc.get('email'),
            img, auth, doc.id, doc.get('visitCount'));
        userProfs.add(userProf);
      }

      return userProfs;
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
