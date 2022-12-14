import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../auth/auth_screens.dart';

class IntroPage3 extends StatelessWidget {
  final bool isSignUp = false;

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(
      color: Colors.black54,
      fontSize: 14.0,
    );
    TextStyle linkStyle = TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    );

    return Container(
      color: Colors.blue[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Come Join us!'),
          Text('Be apart of the community'),
          Text('where we are help each other'),
          SizedBox(
            height: 75,
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AuthScreen(isSignUp);
                },
              ),
            ),
            child: Text('Sign Up'),
          ),
          RichText(
            text: TextSpan(
              style: defaultStyle,
              children: <TextSpan>[
                TextSpan(text: 'Already signed up?'),
                TextSpan(
                  text: 'Log in',
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AuthScreen(!isSignUp);
                          },
                        ),
                      );
                    },
                ),
                TextSpan(text: ' now')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
