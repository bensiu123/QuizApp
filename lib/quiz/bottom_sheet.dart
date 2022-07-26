import 'package:flutter/material.dart';

import '../services/models.dart';
import 'quiz_state.dart';

class OptionDetailBottomSheet extends StatelessWidget {
  const OptionDetailBottomSheet({
    Key? key,
    required this.correct,
    required this.opt,
    required this.state,
  }) : super(key: key);

  final bool correct;
  final Option opt;
  final QuizState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(correct ? 'Good Job!' : 'Wrong'),
          Text(
            opt.detail,
            style: const TextStyle(fontSize: 18, color: Colors.white54),
          ),
          ElevatedButton(
            onPressed: () {
              if (correct) {
                state.nextPage();
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              primary: correct ? Colors.green : Colors.red,
            ),
            child: Text(
              correct ? 'Onward!' : 'Try Again',
              style: const TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
