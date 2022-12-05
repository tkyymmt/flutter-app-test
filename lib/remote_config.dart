import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'error_dispatcher.dart';

Future<void> initRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  bool result = await remoteConfig.fetchAndActivate();
  if (!result) {
    ErrorDispatcher.dispatch('could not fetch or activate remote config');
  }
}
