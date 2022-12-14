import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../../widgets/auth/auth_form.dart';
import './../home/home_screen.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen(this.isSignUp);

  final bool isSignUp;

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAutForm(
    String email,
    String password,
    String username,
    String idmatric,
    String address,
    String gender,
    bool isLogin,
    BuildContext ctx,
  ) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'idmatric': idmatric,
          'address': address,
          'gender': gender,
        });
      }
    } on PlatformException catch (ex) {
      var message = 'An occured, please check your credentials!';

      if (ex.message != null) {
        message = ex.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (ex) {
      print(ex);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            print('**********************login**********************');
            return HomeScreen();
          }
          return AuthForm(
            _submitAutForm,
            _isLoading,
            widget.isSignUp,
          );
        },
      ),
    );
  }
}
