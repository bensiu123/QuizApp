import 'package:fireship_quizapp/services/auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ElevatedButton(
        child: const Text('Sign Out'),
        onPressed: () async {
          final navigator = Navigator.of(context);
          await AuthService().signOut();
          if (navigator.mounted) {
            navigator.pushNamedAndRemoveUntil('/', (route) => false);
          }
        },
      ),
    );
  }
}
