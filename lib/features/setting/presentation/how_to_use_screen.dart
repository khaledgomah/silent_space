import 'package:flutter/material.dart';
import 'package:silent_space/features/setting/data/models/question_model.dart';
import 'package:silent_space/features/setting/presentation/widgets/question_widget.dart';
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
      appBar: AppBar(
        title: Text(S.of(context).howToUse),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) => QuestionWidget(
          questionModel: questions[index],
        ),
      ),
    );
  }
}
