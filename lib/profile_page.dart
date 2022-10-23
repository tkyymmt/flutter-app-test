import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  //const ProfilePage({super.key});
  //const ProfilePage({Key? key, required this.email}) : super(key: key);
  const ProfilePage({super.key, required this.email});

  final String email;

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  //FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = '';

  void _fetchUserProfile() async {
    dynamic docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.email)
        .get();
    name = await docSnapshot.get('name');
    setState(() {});
    /*
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.email)
        .get()
        .then((DocumentSnapshot docSnapshot) =>
            {if (docSnapshot.exists) name = docSnapshot.get('name')})
        .catchError((err) => print("Failed to get user profile: $err"));
        */
  }

  @override
  Widget build(BuildContext context) {
    _fetchUserProfile();

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
              Text(widget.email,
                  style: const TextStyle(fontSize: 24, height: 3)),
              Text(name, style: const TextStyle(fontSize: 24, height: 3))
            ],
          ),
        ));
  }
}
