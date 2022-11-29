import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_dispatcher.dart';

const _vapidKey =
    'BBHLCbsJtWdHPPzN6iaSFJ0KbfREykxVrK8fWYpT9iKtj6zoQN6XKvFmdJfUr8MIQtMHVKk9OTdxXW5IRTF8PhE';
String? _token;
final countProvider = StateProvider(((ref) => 0));
//final uidCountProvider = StateProvider<Map<String, int>>(((ref) => {}));

Future<void> setupMessaging(WidgetRef ref) async {
  try {
    final settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

    _token = await FirebaseMessaging.instance.getToken(vapidKey: _vapidKey);

    print(_token);

    final countStateCtrl = ref.read(countProvider.notifier);
    //final uidCountStateCtrl = ref.read(uidCountProvider.notifier);

    // when the message is received in foreground
    FirebaseMessaging.onMessage.listen(
      (event) {
        print(event.data['visitCount']);
        print(event.data['via']);
        /*
        Map<String, int> uidCount = uidCountStateCtrl.state;
        uidCount[event.data['via']] = event.data['visitCount'];
        uidCountStateCtrl.state = uidCount;
        */
        countStateCtrl.state = int.parse(event.data['visitCount']);
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
