import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uc_auth/pages/create_account.dart';
import 'package:uc_auth/pages/signin.dart';

class AuthView extends StatefulWidget {
  final bool debug;
  final Widget Function(Map<String, String> data) homeScreen;

  const AuthView({
    super.key,
    required this.debug,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        bool web = constraints.maxWidth >= 700;
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: SafeArea(
            child: Center(
              child: SizedBox(
                width: web ? MediaQuery.of(context).size.width * 0.5 : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() {
                                    signIn = true;
                                  }),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: signIn
                                          ? Colors.white
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      signIn = false;
                                    }),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: !signIn
                                            ? Colors.white
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            'Create Account',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 52),
                            signIn
                                ? SignIn(body: body, homeScreen: widget.homeScreen, debug: widget.debug,)
                                : CreateAccount(
                                    body: body,
                                    homeScreen: widget.homeScreen,
                              debug: widget.debug,
                                  ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
