import 'package:flutter/material.dart';
import 'package:test/store.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  String name = '';

  void _setProfile() async {
    name = await fetchUserProfile();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _setProfile();

    return Scaffold(
        appBar: AppBar(title: const Text('Profile Page')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 100,
                child: Icon(Icons.person, size: 130),
              ),
              Text(FirebaseAuth.instance.currentUser!.email.toString(),
                  style: const TextStyle(fontSize: 24, height: 3)),
              Text(name, style: const TextStyle(fontSize: 24, height: 3))
            ],
          ),
        ));
  }
}
