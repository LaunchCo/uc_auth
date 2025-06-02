import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // Sign into an existing account in the UC
  Future<Map<String, String>> signIn(String username, String password) async {
    try {
      final credentials = base64Encode(utf8.encode('$username:$password'));
      final response = await http.post(
        Uri.parse('https://launchco.uc.r.appspot.com/api/auth/login/'),
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
    String app,
  ) async {
    try {
      final uri = Uri.parse('https://launchco.uc.r.appspot.com/api/register/');

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
        throw Exception(
          'Failed to create account: ${createResponse.statusCode}',
        );
      }

      // Step 2: Sign in to get the auth token
      final credentials = base64Encode(utf8.encode('$email:$password'));
      final signInResponse = await http.post(
        Uri.parse('https://launchco.uc.r.appspot.com/api/auth/login/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $credentials',
        },
      );

      if (signInResponse.statusCode != 200) {
        throw Exception(
          'Failed to sign in after account creation: ${signInResponse.statusCode}',
        );
      }

      final signInData = json.decode(signInResponse.body);
      final authToken = signInData['token'];

      // Step 3: Create the user createUser
      final createUserResponse = await http.post(
        Uri.parse('https://launchco.uc.r.appspot.com/api/$app/create-user/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $authToken',
        },
      );

      if (createUserResponse.statusCode != 200 &&
          createUserResponse.statusCode != 201) {
        throw Exception(
          'Failed to create user createUser: ${createUserResponse.statusCode}',
        );
      }
      return {"token": authToken, "expiry": signInData["expiry"]};
    } catch (e) {
      throw Exception('Account creation error: $e');
    }
  }
}
