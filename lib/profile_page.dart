import 'package:flutter/material.dart';
import 'package:test/dao.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final UserDAO dao = UserDAO();
  UserProfile userProf = UserProfile(name: '', email: '');

  void _setProfile() async {
    userProf = await dao.getCurrentUser();
    if (mounted) setState(() {});
  }

  bool _editMode = false;

  final _nameEditController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _setProfile();

    return Scaffold(
        appBar: AppBar(title: const Text('Profile Page')),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              const Padding(padding: EdgeInsets.all(20)),
              const CircleAvatar(
                radius: 100,
                child: Icon(Icons.person, size: 130),
              ),
              const Padding(padding: EdgeInsets.all(20)),
              Text(userProf.email,
                  style: const TextStyle(fontSize: 24, height: 2)),
              if (!_editMode) ...[
                Text(userProf.name,
                    style: const TextStyle(fontSize: 24, height: 2)),
                const Padding(padding: EdgeInsets.all(10)),
                SizedBox(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _editMode = true;
                          });
                        },
                        child:
                            const Text('Edit', style: TextStyle(fontSize: 24))))
              ] else ...[
                SizedBox(
                    height: 50,
                    width: 300,
                    child: TextFormField(
                      initialValue: userProf.name,
                      autofocus: true,
                      style: const TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        labelText: '名前',
                      ),
                    )),
                const Padding(padding: EdgeInsets.all(10)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: 40,
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _editMode = false;
                                  //dao.updateCurrentUser(_nameEditController.text, userProf.email);
                                });
                              },
                              child: const Text('Save',
                                  style: TextStyle(fontSize: 24)))),
                      const Padding(padding: EdgeInsets.all(10)),
                      SizedBox(
                          height: 40,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _editMode = false;
                                });
                              },
                              child: const Text('Cancel',
                                  style: TextStyle(fontSize: 24))))
                    ])
              ],
            ]))));
  }
}
