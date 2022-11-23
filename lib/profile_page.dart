import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test/auth.dart';
import 'package:test/dao.dart';
import 'package:test/user_profile.dart';

final _editModeProvider = StateProvider((_) => false);

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editMode = ref.watch(_editModeProvider);
    final name = ref.watch(userNameProvider);
    final email = ref.watch(userEmailProvider);
    final img = ref.watch(userImageProvider);

    return Scaffold(
        appBar: AppBar(title: const Text('Profile Page')),
        body: name == null || email == null || img == null
            ? const LinearProgressIndicator()
            : SingleChildScrollView(
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                    const Padding(padding: EdgeInsets.all(20)),
                    CircleAvatar(radius: 100, child: img),
                    const Padding(padding: EdgeInsets.all(20)),
                    Text(email,
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
    final editMode = ref.watch(_editModeProvider.notifier);
    final name = ref.watch(userNameProvider);

    return Column(children: <Widget>[
      Text(name!, style: const TextStyle(fontSize: 24, height: 2)),
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
  final _nameCtrl = TextEditingController();
  final _nameFormKey = GlobalKey<FormFieldState>();

  String? _nameValidator(value) {
    if (value == null || value.isEmpty) {
      return "名前を入力してください";
    }
    return null;
  }

  void _savePressed(BuildContext context, WidgetRef ref) async {
    final name = ref.watch(userNameProvider);

    if (_nameFormKey.currentState!.validate()) {
      if (_nameCtrl.text != name!) {
        final dao = ref.read(userDAOProvider);
        final String errMsg = await dao.updateCurrentUserName(_nameCtrl.text);
        if (errMsg.isEmpty) {
          // このコード実行後に別アカウントにログインしても前のユーザー情報が表示される
          ref.watch(userNameProvider.notifier).state = _nameCtrl.text;
          /*
          // this causes Error: Looking up a deactivated widget's ancestor is unsafe.
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('名前を変更しました')));
              */
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
    final editMode = ref.watch(_editModeProvider.notifier);
    final name = ref.watch(userNameProvider);
    _nameCtrl.text = name!;

    return Column(children: <Widget>[
      SizedBox(
          height: 50,
          width: 300,
          child: TextFormField(
            key: _nameFormKey,
            validator: (value) => _nameValidator(value),
            controller: _nameCtrl,
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
