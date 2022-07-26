import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../services/models.dart';
import 'quiz_state.dart';
import 'bottom_sheet.dart';

class QuestionPage extends StatelessWidget {
  final Question question;
  const QuestionPage({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<QuizState>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(question.text),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: question.options.map((opt) {
              return OptionPressable(state: state, opt: opt);
            }).toList(),
          ),
        )
      ],
    );
  }
}

class OptionPressable extends StatelessWidget {
  const OptionPressable({
    Key? key,
    required this.state,
    required this.opt,
  }) : super(key: key);

  final QuizState state;
  final Option opt;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.black26,
      child: InkWell(
        onTap: () {
          state.selected = opt;
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return OptionDetailBottomSheet(
                correct: opt.correct,
                opt: opt,
                state: state,
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                state.selected == opt
                    ? FontAwesomeIcons.circleCheck
                    : FontAwesomeIcons.circle,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: Text(
                    opt.value,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
