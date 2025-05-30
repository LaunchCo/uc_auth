import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uc_auth/services/api_service.dart';

class SignIn extends StatefulWidget {
  final TextStyle body;
  final Widget Function(Map<String, String> data) homeScreen;

  const SignIn({super.key, required this.body, required this.homeScreen});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: kIsWeb
              ? MediaQuery.of(context).size.width * 0.2
              : MediaQuery.of(context).size.width * 0.8,
          child: AutofillGroup(
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  style: widget.body,
                  autofillHints: const [
                    AutofillHints.username,
                    AutofillHints.email,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: widget.body,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  style: widget.body,
                  autofillHints: const [AutofillHints.password],
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: widget.body,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 16),
          Text(_errorMessage!, style: widget.body.copyWith(color: Colors.red)),
        ],
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () async {
                  setState(() {
                    _isLoading = true;
                  });
                  final response = await ApiService().signIn(
                    _usernameController.text,
                    _passwordController.text,
                  );
                  if (response["status"] == "200") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => widget.homeScreen(response),
                      ),
                    );
                  } else {
                    setState(() {
                      _errorMessage = response["error"];
                    });
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.black)
              : Text(
                  'Sign In',
                  style: widget.body.copyWith(color: Colors.black),
                ),
        ),
      ],
    );
  }
}
