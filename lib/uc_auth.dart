import 'package:flutter/material.dart';
import 'package:uc_auth/pages/create_account.dart';
import 'package:uc_auth/pages/signin.dart';
import 'package:uc_auth/services/home_abstract_class.dart';
export 'package:uc_auth/uc_auth.dart';

class AuthView extends StatefulWidget {
  final String createUserUrl;
  final HomeScreen homeScreen;

  const AuthView({
    super.key,
    required this.createUserUrl,
    required this.homeScreen,
  });

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final body = TextStyle(fontSize: 16, color: Colors.black);
  bool signIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          signIn = true;
                        }),
                        child: Container(
                          color: signIn ? Colors.white : Colors.grey.shade100,
                          child: Text(
                            'Sign In',
                            style: TextStyle(fontSize: 28, color: Colors.black),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          signIn = false;
                        }),
                        child: Container(
                          color: !signIn ? Colors.white : Colors.grey.shade100,
                          child: Text(
                            'Create Account',
                            style: TextStyle(fontSize: 28, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  signIn
                      ? SignIn(body: body, homeScreen: widget.homeScreen)
                      : CreateAccount(
                    body: body,
                    homeScreen: widget.homeScreen,
                    createUserUrl: widget.createUserUrl,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

