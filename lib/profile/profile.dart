import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../login/login.dart';
import '../services/auth.dart';
import '../services/models.dart';
import '../shared/error.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final report = Provider.of<Report>(context);
    final user = AuthService().user;

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(user.displayName ?? 'Guest'),
          backgroundColor: Colors.deepOrange,
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      user.photoURL ??
                          'https://www.gravatar.com/avatar/placeholder',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                user.email ?? '',
                style: Theme.of(context).textTheme.headline6,
              ),
              const Spacer(),
              if (AuthService().user?.isAnonymous ?? false)
                LoginButton(
                  icon: FontAwesomeIcons.google,
                  text: 'Sign in with Google',
                  loginMethod: AuthService().signInWithGoogle,
                  color: Colors.blue,
                ),
              Text(
                report.total.toString(),
                style: Theme.of(context).textTheme.headline2,
              ),
              Text(
                'Quizzes Completed',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  await AuthService().signOut();
                  navigator.pushNamedAndRemoveUntil('/', (route) => false);
                },
                child: const Text('Sign Out'),
              )
            ],
          ),
        ),
      );
    } else {
      return const Scaffold(
        body: ErrorMessage(
          message: 'Unauthorized access',
        ),
      );
    }
  }
}
