import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/remote_config.dart';

import 'error_dispatcher.dart';

String? _token;
final uidCountProvider = StateProvider<Map<String, int>>(((ref) => {}));

Future<void> setupMessaging(WidgetRef ref) async {
  try {
    final settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

    await initRemoteConfig();
    final vapidKey = FirebaseRemoteConfig.instance.getString('vapidKey');
    _token = await FirebaseMessaging.instance.getToken(vapidKey: vapidKey);

    final uidCountStateCtrl = ref.read(uidCountProvider.notifier);

    // when the message is received in foreground
    FirebaseMessaging.onMessage.listen(
      (event) {
        ErrorDispatcher.dispatch(
            event.data['via'] + ' ' + event.data['visitCount']);
        uidCountStateCtrl.state = <String, int>{
          event.data['via']: int.parse(event.data['visitCount'])
        };
      },
    );
  } catch (e) {
    ErrorDispatcher.dispatch(e.toString());
  }
}

Future<bool> sendCount() async {
  if (_token == null) return false;

  final callable = FirebaseFunctions.instance.httpsCallable(
    'sendCount',
  );
  final arg = json.encode({'token': _token});
  final HttpsCallableResult<bool> res = await callable(arg);

  return res.data;
}
