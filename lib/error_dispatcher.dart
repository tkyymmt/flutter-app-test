import 'package:http/http.dart' as http;
import 'dart:convert';

// dispatch error message to discord channel
// This App --> Cloud Functions --> Discord Channel
class ErrorDispatcher {
  static dispatch(String errMsg) async {
    const url =
        'https://us-central1-web-app-test-752a1.cloudfunctions.net/errDispatcher';
    final uri = Uri.parse(url);
    await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({'error': errMsg}));
  }
}
