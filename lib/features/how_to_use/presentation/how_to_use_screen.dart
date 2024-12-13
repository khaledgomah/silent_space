import 'package:flutter/material.dart';
import 'package:silent_space/generated/l10n.dart';

class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<QuestionModel> questions = <QuestionModel>[
      QuestionModel(
        question: S.of(context).configurwNotificationQuestion,
        answer: S.of(context).configurwNotificationAnswer,
      ),
    ];
    return Scaffold(
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) => QuestionWidget(
          questionModel: questions[index],
        ),
      ),
    );
  }
}

class QuestionModel {
  final String question;
  final String answer;

  const QuestionModel({required this.question, required this.answer});
}

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
