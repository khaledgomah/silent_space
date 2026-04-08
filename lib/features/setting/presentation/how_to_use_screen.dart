import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/features/setting/data/models/question_model.dart';
import 'package:silent_space/features/setting/presentation/widgets/question_widget.dart';

class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<QuestionModel> questions = <QuestionModel>[
      QuestionModel(
        question: AppStrings.configureNotificationQuestion.tr(),
        answer: AppStrings.configureNotificationAnswer.tr(),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.howToUse.tr()),
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
