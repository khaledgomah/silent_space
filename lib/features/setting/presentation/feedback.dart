import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/constants.dart';
import 'package:silent_space/core/widgets/custom_button.dart';
import 'package:silent_space/core/widgets/custom_text_form_field.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late final TextEditingController _feedbackController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _feedbackController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

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
                          : AppStrings.noMailError.tr());
                } else {
                  final Email email = Email(
                    body: 'User Email: ${_emailController.text.trim()}\n\nFeedback:\n${_feedbackController.text}',
                    subject: Constants.emailSubject,
                    recipients: [Constants.myMail],
                    isHTML: false,
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
