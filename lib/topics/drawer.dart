import 'package:flutter/material.dart';

import 'package:fireship_quizapp/services/models.dart';
import 'package:fireship_quizapp/topics/quiz_list.dart';

class TopicsDrawer extends StatelessWidget {
  final List<Topic> topics;
  const TopicsDrawer({Key? key, required this.topics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Text(
                  topic.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),
              QuizList(topic: topic)
            ],
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
