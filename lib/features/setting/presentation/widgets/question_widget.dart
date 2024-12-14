import 'package:flutter/material.dart';
import 'package:silent_space/features/setting/data/models/question_model.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({super.key, required this.questionModel});
  final QuestionModel questionModel;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(questionModel.question),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(questionModel.answer),
        ),
      ],
    );
  }
}
