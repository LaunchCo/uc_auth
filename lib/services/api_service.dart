import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // Sign into an existing account in the UC
  Future<Map<String, String>> signIn(
    String username,
    String password,
    bool debug,
  ) async {
    final url = debug ? debugUrl : prodUrl;
    try {
      final credentials = base64Encode(utf8.encode('$username:$password'));
      final response = await http.post(
        Uri.parse('$url/api/auth/login/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $credentials',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final authToken = responseData['token'];
        return {
          "token": authToken,
          "expiry": responseData['expiry'],
          "status": "${response.statusCode}",
        };
      } else {
        return {"status": "${response.statusCode}"};
      }
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  /// Creates a new account in the UC
  Future<Map<String, String>> createAccount(
    String username,
    String email,
    String password,
    bool debug,
  ) async {
    final url = debug ? debugUrl : prodUrl;
    try {
      final uri = Uri.parse('$url/api/register/');

      final createResponse = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (createResponse.statusCode != 201 &&
          createResponse.statusCode != 200) {
        return {
          "error": "Failed to create account: ${createResponse.statusCode}",
        };
      }

      // Step 2: Sign in to get the auth token
      final credentials = base64Encode(utf8.encode('$email:$password'));
      final signInResponse = await http.post(
        Uri.parse('$url/api/auth/login/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $credentials',
        },
      );

      if (signInResponse.statusCode != 200) {
        return {
          "error":
              "Failed to sign in after account creation: ${signInResponse.statusCode}",
        };
      }

      final signInData = json.decode(signInResponse.body);
      final authToken = signInData['token'];

      return {
        "token": authToken,
        "expiry": signInData["expiry"],
        "status": "200",
      };
    } catch (e) {
      return {"error": "Account creation error: $e"};
    }
  }
}

const String prodUrl = "https://launchco.uc.r.appspot.com";
const String debugUrl = "http://127.0.0.1:8000";
