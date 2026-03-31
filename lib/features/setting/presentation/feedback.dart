import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/constants.dart';
import 'package:silent_space/core/widgets/custom_button.dart';
import 'package:silent_space/core/widgets/custom_text_form_field.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.feedback.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(
              borderRadius: 16,
              hintText: AppStrings.enterYourMail.tr(),
              controller: _emailController,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              borderRadius: 16,
              hintText: AppStrings.enterYourFeedback.tr(),
              maxLines: 5,
              controller: _feedbackController,
            ),
            const SizedBox(height: 20),
            CustomButton(
              child: Text(AppStrings.send.tr()),
              onPressed: () async {
                if (_feedbackController.text.isEmpty || _emailController.text.isEmpty) {
                  showSnackBar(
                      context,
                      _feedbackController.text.isEmpty
                          ? AppStrings.noFeedbackError.tr()
                          : AppStrings.noMailErro.tr());
                } else {
                  final Email email = Email(
                    body: _feedbackController.text,
                    subject: Constants.emailSubject,
                    recipients: [Constants.myMail],
                    isHTML: false, // النص عادي
                  );
                  try {
                    await FlutterEmailSender.send(email);
                    if (context.mounted) {
                      showSnackBar(context, AppStrings.feedbackSent.tr());
                    }
                  } catch (error) {
                    if (context.mounted) {
                      showSnackBar(context, AppStrings.feedbackNotSent.tr());
                    }
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
