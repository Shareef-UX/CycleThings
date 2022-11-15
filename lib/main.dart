import 'package:app_donation/screens/profile/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './screens/home/home_screen.dart';
import './screens/intro/intro_screen.dart';
import './screens/goods/goods_detail_screen.dart';
import './screens/message/message_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CycleThings',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        backgroundColor: Colors.green,
        accentColor: Colors.purple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.green,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            print('**********************login**********************');
            return HomeScreen();
          }
          return IntroScreen();
        },
      ),
      routes: {
        GoodsDetailScreen.routeName: (ctx) => GoodsDetailScreen(),
        MessageScreen.routeName: (ctx) => MessageScreen(),
        ProfileScreen.routeName: (ctx) => ProfileScreen(),
      },
    );
  }
}
