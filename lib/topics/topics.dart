import 'package:fireship_quizapp/services/firestore.dart';
import 'package:fireship_quizapp/shared/error.dart';
import 'package:fireship_quizapp/topics/topic_item.dart';
import 'package:flutter/material.dart';
import 'package:fireship_quizapp/services/models.dart';
import 'package:fireship_quizapp/shared/bottom_nav.dart';
import 'package:fireship_quizapp/shared/loading.dart';
import 'package:fireship_quizapp/topics/drawer.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Topic>>(
      future: FirestoreService().getTopics(),
      builder: ((context, snapshot) {
        print(
          "TopicsScreen: ${snapshot.connectionState}: [${DateTime.now().toIso8601String()}]",
        );

        if (snapshot.connectionState == ConnectionState.waiting) {
          // loading
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          // error
          return ErrorMessage(message: snapshot.error?.toString() ?? '');
        } else if (snapshot.hasData) {
          // normal
          var topics = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: const Text('Topics'),
            ),
            drawer: TopicsDrawer(topics: topics),
            body: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              crossAxisCount: 2,
              children: topics.map((topic) => TopicItem(topic: topic)).toList(),
            ),
            bottomNavigationBar: const BottomNavBar(),
          );
        } else {
          // empty
          return const ErrorMessage(
            message: 'No topics found in Firestore. Check database.',
          );
        }
      }),
    );
  }
}
