import 'package:flutter/material.dart';

import '../services/firestore.dart';
import '../services/models.dart';
import '../shared/bottom_nav.dart';
import '../shared/error.dart';
import '../shared/loading.dart';
import 'drawer.dart';
import 'topic_item.dart';

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
