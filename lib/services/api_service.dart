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
      print(1);
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
      print(2);

      if (createResponse.statusCode != 201 &&
          createResponse.statusCode != 200) {
        print(3);
        throw Exception(
          'Failed to create account: ${createResponse.statusCode}',
        );
      }

      print(4);

      // Step 2: Sign in to get the auth token
      final credentials = base64Encode(utf8.encode('$email:$password'));
      final signInResponse = await http.post(
        Uri.parse('https://launchco.uc.r.appspot.com/api/auth/login/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $credentials',
        },
      );
      print(5);

      if (signInResponse.statusCode != 200) {
        print(6);
        throw Exception(
          'Failed to sign in after account creation: ${signInResponse.statusCode}',
        );
      }

      print(7);

      final signInData = json.decode(signInResponse.body);
      final authToken = signInData['token'];

      print(8);

      // Step 3: Create the user createUser
      final createUserResponse = await http.post(
        Uri.parse('https://launchco.uc.r.appspot.com/api/$app/create-user/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $authToken',
        },
      );

      print(9);

      if (createUserResponse.statusCode != 200 &&
          createUserResponse.statusCode != 201) {
        print(10);
        throw Exception(
          'Failed to create user createUser: ${createUserResponse.statusCode}',
        );
      }
      print(11);
      return {"token": authToken, "expiry": signInData["expiry"]};
    } catch (e) {
      print(12);
      print(3);
      throw Exception('Account creation error: $e');
    }
  }
}
