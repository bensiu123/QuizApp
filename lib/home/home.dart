import 'package:flutter/material.dart';

import '../login/login.dart';
import '../services/auth.dart';
import '../topics/topics.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // waiting for data
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // error
            return const Center(
              child: Text('Error'),
            );
          } else if (snapshot.hasData) {
            // logged in
            return const TopicsScreen();
          } else {
            // not logged in
            return const LoginScreen();
          }
        });
  }
}
