import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/dao.dart';

import 'messaging.dart';

final userProfilesProvider =
    FutureProvider.autoDispose((ref) => ref.read(userDAOProvider).fetchUsers());

// USE mixin
class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitCount = ref.watch(countProvider);
    //final uidCount = ref.watch(uidCountProvider);
    final userProfs = ref.watch(userProfilesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Page')),
      body: userProfs.maybeWhen(
        data: ((userProfs) {
          if (userProfs == null) return const LinearProgressIndicator();

          return ListView.builder(
              itemCount: userProfs.length,
              itemBuilder: (context, index) {
                final userProf = userProfs[index];
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(radius: 50, child: userProf.img),
                      Column(
                        children: [Text(userProf.name), Text(userProf.email)],
                      ),
                      ElevatedButton(
                          onPressed: (() => print('PRESSED')),
                          child: const Text('Edit')),
                      Text(userProf.visitCount.toString()),
                      //Text(uidCount[userProf.uid].toString()),
                    ],
                  ),
                );
              });
        }),
        orElse: () => const LinearProgressIndicator(),
      ),
    );
  }
}
