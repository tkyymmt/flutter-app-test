import 'package:flutter/material.dart';
import 'package:test/dao.dart';
import 'package:test/user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  UserProfile? userProf;
  static bool editMode = false;

  void _initUserProf() async {
    UserDAO dao = UserDAO();
    userProf = await dao.fetchUser();
    if (userProf == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('could not fetch your profile',
              style: TextStyle(color: Colors.red))));
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _initUserProf();

    // display progress indicator while fetching user profile info
    if (userProf == null) {
      return Scaffold(
          appBar: AppBar(title: const Text('Profile Page')),
          body: const LinearProgressIndicator());
    }

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
              Text(userProf!.email,
                  style: const TextStyle(fontSize: 24, height: 2)),
              if (!editMode) ...[
                _ProfileColumn(prof: userProf!)
              ] else ...[
                _ProfileEditColumn(prof: userProf!)
              ],
            ]))));
  }
}

class _ProfileColumn extends StatefulWidget {
  const _ProfileColumn({required this.prof});

  final UserProfile prof;

  @override
  State<_ProfileColumn> createState() => _ProfileColumnState();
}

class _ProfileColumnState extends State<_ProfileColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(widget.prof.name, style: const TextStyle(fontSize: 24, height: 2)),
      const Padding(padding: EdgeInsets.all(10)),
      SizedBox(
          width: 200,
          height: 40,
          child: ElevatedButton(
              onPressed: () => setState(
                  () => _ProfilePage.editMode = !_ProfilePage.editMode),
              child: const Text('Edit', style: TextStyle(fontSize: 24))))
    ]);
  }
}

class _ProfileEditColumn extends StatefulWidget {
  const _ProfileEditColumn({required this.prof});

  final UserProfile prof;

  @override
  State<_ProfileEditColumn> createState() => _ProfileEditColumnState();
}

class _ProfileEditColumnState extends State<_ProfileEditColumn> {
  String _nameStr = '';
  final _nameFormKey = GlobalKey<FormFieldState>();

  String? _nameValidator(value) {
    if (value == null || value.isEmpty) {
      return "名前を入力してください";
    }
    _nameStr = value.toString();
    return null;
  }

  void _savePressed(context) async {
    if (_nameFormKey.currentState!.validate()) {
      if (_nameStr != widget.prof.name) {
        UserDAO dao = UserDAO();
        final String errMsg = await dao.updateCurrentUserName(_nameStr);
        if (errMsg.isEmpty) {
          widget.prof.name = _nameStr;
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('名前を変更しました')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text(errMsg, style: const TextStyle(color: Colors.red))));
        }
      }
    }
    setState(() => _ProfilePage.editMode = !_ProfilePage.editMode);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(
          height: 50,
          width: 300,
          child: TextFormField(
            key: _nameFormKey,
            validator: (value) => _nameValidator(value),
            initialValue: widget.prof.name,
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
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        SizedBox(
            height: 40,
            child: ElevatedButton(
                onPressed: () => _savePressed(context),
                child: const Text('Save', style: TextStyle(fontSize: 24)))),
        const Padding(padding: EdgeInsets.all(10)),
        SizedBox(
            height: 40,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: () => setState(
                    () => _ProfilePage.editMode = !_ProfilePage.editMode),
                child: const Text('Cancel', style: TextStyle(fontSize: 24))))
      ])
    ]);
  }
}
