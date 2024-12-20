import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/utils/constans.dart';
import 'package:silent_space/core/widgets/custom_button.dart';
import 'package:silent_space/core/widgets/custom_text_form_field.dart';
import 'package:silent_space/generated/l10n.dart';

class FeedbackScreen extends StatelessWidget {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  FeedbackScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).feedback),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(
              borderRadius: 16,
              hintText: S.of(context).enterYourMail,
              controller: _emailController,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              borderRadius: 16,
              hintText: S.of(context).enterYourFeedback,
              maxLines: 5,
              controller: _feedbackController,
            ),
            const SizedBox(height: 20),
            CustomButton(
              child: Text(S.of(context).send),
              onPressed: () async {
                if (_feedbackController.text.isEmpty ||
                    _emailController.text.isEmpty) {
                  showSnackBar(
                      context,
                      _feedbackController.text.isEmpty
                          ? S.of(context).noFeedbackError
                          : S.of(context).noMailErro);
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
                      showSnackBar( context, S.of(context).feedbackSent);
                    }
                  } catch (error) {
                    if (context.mounted) {
                      showSnackBar(
                          context, S.of(context).feedbackNotSent);
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
