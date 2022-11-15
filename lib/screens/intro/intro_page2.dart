import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Donate and Retrieve'),
          Text('Donate what you loved to a person in need'),
        ],
      ),
    );
  }
}
