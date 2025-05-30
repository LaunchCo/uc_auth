import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uc_auth/services/api_service.dart';

class CreateAccount extends StatefulWidget {
  final TextStyle body;
  final Widget Function(Map<String, String> data) homeScreen;
  final String createUserUrl;

  const CreateAccount({
    super.key,
    required this.body,
    required this.homeScreen,
    required this.createUserUrl,
  });

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
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
                  autofillHints: const [AutofillHints.username],
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
                  controller: _emailController,
                  style: widget.body,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(
                    labelText: 'Email',
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
              _errorMessage = "";
            });
                  if (_usernameController.text.isNotEmpty &&
                      _emailController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty) {
                    setState(() {
                      _isLoading = true;
                    });
                    final response = await ApiService().createAccount(
                      _usernameController.text,
                      _emailController.text,
                      _passwordController.text,
                      widget.createUserUrl,
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
                  } else {
                    setState(() {
                      _errorMessage = "Please fill out all fields";
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
