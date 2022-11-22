import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test/auth.dart';
import 'package:test/dao.dart';
import 'package:test/login_page.dart';
import 'package:test/user_profile.dart';

final editModeProvider = StateProvider((_) => false);

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProf = ref.watch(userProfileProvider);

    final profImg = ref.watch(profImgProvider);
    final editMode = ref.watch(editModeProvider);

    /*
    return Scaffold(
        appBar: AppBar(title: const Text('Profile Page')),
        body: userProf.when(
            data: ((data) {
              return SingleChildScrollView(
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
                    Text(data!.email,
                        key: const ValueKey('emailKey'),
                        style: const TextStyle(fontSize: 24, height: 2)),
                    if (!editMode) ...[
                      _ProfileColumn(),
                const Padding(padding: EdgeInsets.all(20)),
                      _LogoutButton()
                    ] else ...[
                      //_ProfileEditColumn()
                    ]
                  ])));
            }),
            error: ((error, stackTrace) => Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.red),
                )),
            loading: (() => const LinearProgressIndicator())));
            */
    return Scaffold(
        appBar: AppBar(title: const Text('Profile Page')),
        body: userProf == null
            ? const LinearProgressIndicator()
            : SingleChildScrollView(
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                    const Padding(padding: EdgeInsets.all(20)),
                    CircleAvatar(child: profImg.value, radius: 100),
                    const Padding(padding: EdgeInsets.all(20)),
                    Text(userProf.email,
                        key: const ValueKey('emailKey'),
                        style: const TextStyle(fontSize: 24, height: 2)),
                    if (!editMode) ...[
                      _ProfileColumn(),
                      const Padding(padding: EdgeInsets.all(20)),
                      _LogoutButton()
                    ] else ...[
                      _ProfileEditColumn()
                    ],
                  ]))));
  }
}

class _ProfileColumn extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProf = ref.watch(userProfileProvider);
    final editMode = ref.watch(editModeProvider.notifier);

    return Column(children: <Widget>[
      Text(userProf!.name, style: const TextStyle(fontSize: 24, height: 2)),
      const Padding(padding: EdgeInsets.all(10)),
      SizedBox(
          width: 200,
          height: 40,
          child: ElevatedButton(
              onPressed: () => editMode.state = !editMode.state,
              child: const Text('Edit', style: TextStyle(fontSize: 24))))
    ]);
  }
}

class _ProfileEditColumn extends ConsumerWidget {
  String _nameStr = '';
  final _nameFormKey = GlobalKey<FormFieldState>();

  String? _nameValidator(value) {
    if (value == null || value.isEmpty) {
      return "名前を入力してください";
    }
    _nameStr = value.toString();
    return null;
  }

  void _savePressed(BuildContext context, WidgetRef ref) async {
    final userProf = ref.watch(userProfileProvider);

    if (_nameFormKey.currentState!.validate()) {
      if (_nameStr != userProf!.name) {
        final dao = ref.read(userDAOProvider);
        final String errMsg = await dao.updateCurrentUserName(_nameStr);
        if (errMsg.isEmpty) {
          ref.read(userProfileProvider.notifier).state =
              UserProfile(_nameStr, userProf.email, userProf.imgURL);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('名前を変更しました')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text(errMsg, style: const TextStyle(color: Colors.red))));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProf = ref.watch(userProfileProvider);
    final editMode = ref.watch(editModeProvider.notifier);

    return Column(children: <Widget>[
      SizedBox(
          height: 50,
          width: 300,
          child: TextFormField(
            key: _nameFormKey,
            validator: (value) => _nameValidator(value),
            initialValue: userProf!.name,
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
                onPressed: () {
                  _savePressed(context, ref);
                  editMode.state = !editMode.state;
                },
                child: const Text('Save', style: TextStyle(fontSize: 24)))),
        const Padding(padding: EdgeInsets.all(10)),
        SizedBox(
            height: 40,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: () => editMode.state = !editMode.state,
                child: const Text('Cancel', style: TextStyle(fontSize: 24))))
      ])
    ]);
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        height: 40,
        child: ElevatedButton(
            onPressed: () async {
              String errMsg = await signOutUser();
              if (errMsg.isEmpty) {
                context.go('/login');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(errMsg,
                        style: const TextStyle(color: Colors.red))));
              }
            },
            child: const Text('ログアウト', style: TextStyle(fontSize: 24))));
  }
}
