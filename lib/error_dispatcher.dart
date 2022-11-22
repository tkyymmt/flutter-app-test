import 'package:cloud_functions/cloud_functions.dart';

// dispatch error message to discord channel
// This App --> Cloud Functions --> Discord Channel
class ErrorDispatcher {
  /// returns true if error dispatch is succeeded
  /// otherwise reutnrs false
  static Future<bool> dispatch(String errMsg) async {
    final callable = FirebaseFunctions.instance.httpsCallable(
      'errDispatcher',
    );
    final HttpsCallableResult<bool> res = await callable(errMsg);

    return res.data;
  }
}
