import 'package:flutter/material.dart';
import 'package:test/dao.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  static UserDAO dao = UserDAO();
  static bool editMode = false;

  void _initDAO() async {
    final String errMsg = await dao.fetchUser();
    if (errMsg.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errMsg, style: const TextStyle(color: Colors.red))));
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _initDAO();

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
              Text(dao.userProf.email,
                  style: const TextStyle(fontSize: 24, height: 2)),
              if (!editMode) ...[
                _ProfileColumn()
              ] else ...[
                _ProfileEditColumn()
              ],
            ]))));
  }
}

class _ProfileColumn extends StatefulWidget {
  @override
  State<_ProfileColumn> createState() => _ProfileColumnState();
}

class _ProfileColumnState extends State<_ProfileColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(_ProfilePage.dao.userProf.name,
          style: const TextStyle(fontSize: 24, height: 2)),
      const Padding(padding: EdgeInsets.all(10)),
      SizedBox(
          width: 200,
          height: 40,
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _ProfilePage.editMode = true;
                });
              },
              child: const Text('Edit', style: TextStyle(fontSize: 24))))
    ]);
  }
}

class _ProfileEditColumn extends StatefulWidget {
  @override
  State<_ProfileEditColumn> createState() => _ProfileEditColumnState();
}

class _ProfileEditColumnState extends State<_ProfileEditColumn> {
  String _nameStr = '';
  final _nameFormKey = GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(
          height: 50,
          width: 300,
          child: TextFormField(
            key: _nameFormKey,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "名前を入力してください";
              }
              _nameStr = value.toString();
              return null;
            },
            initialValue: _ProfilePage.dao.userProf.name,
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
                onPressed: () async {
                  if (_nameFormKey.currentState!.validate()) {
                    if (_nameStr != _ProfilePage.dao.userProf.name) {
                      final String errMsg =
                          await _ProfilePage.dao.updateCurrentUser(_nameStr);
                      if (errMsg.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('名前を変更しました')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(errMsg,
                                style: const TextStyle(color: Colors.red))));
                      }
                    }
                    setState(() {
                      _ProfilePage.editMode = false;
                    });
                  }
                },
                child: const Text('Save', style: TextStyle(fontSize: 24)))),
        const Padding(padding: EdgeInsets.all(10)),
        SizedBox(
            height: 40,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: () {
                  setState(() {
                    _ProfilePage.editMode = false;
                  });
                },
                child: const Text('Cancel', style: TextStyle(fontSize: 24))))
      ])
    ]);
  }
}
