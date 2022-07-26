import 'quiz_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../services/firestore.dart';
import '../services/models.dart';
import '../shared/error.dart';
import '../shared/loading.dart';
import '../shared/progress_bar.dart';
import 'congrats.dart';
import 'question.dart';
import 'start.dart';

class QuizScreen extends StatelessWidget {
  final String quizId;

  const QuizScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizState(),
      child: FutureBuilder<Quiz>(
        future: FirestoreService().getQuiz(quizId),
        builder: ((context, snapshot) {
          final state = Provider.of<QuizState>(context);

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return ErrorMessage(message: snapshot.error.toString());
          } else {
            final quiz = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
                title: AnimatedProgressBar(value: state.progress),
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(FontAwesomeIcons.xmark),
                ),
              ),
              body: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: state.controller,
                onPageChanged: ((value) =>
                    state.progress = (value / (quiz.questions.length + 1))),
                itemBuilder: ((context, index) {
                  if (index == 0) {
                    return StartPage(quiz: quiz);
                  } else if (index == quiz.questions.length + 1) {
                    return CongratsPage(quiz: quiz);
                  } else {
                    return QuestionPage(
                      question: quiz.questions[index - 1],
                    );
                  }
                }),
              ),
            );
          }
        }),
      ),
    );
  }
}
