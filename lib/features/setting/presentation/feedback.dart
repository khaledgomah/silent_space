import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/widgets/custom_button.dart';
import 'package:silent_space/core/widgets/custom_text_form_field.dart';

class FeedbackScreen extends StatelessWidget {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  FeedbackScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(
              borderRadius: 16,
              hintText: 'Enter your mail',
              controller: _emailController,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              borderRadius: 16,
              hintText: 'Enter your feedback here...',
              maxLines: 5,
              controller: _feedbackController,
            ),
            const SizedBox(height: 20),
            CustomButton(
              child: const Text('SendFeedback'),
              onPressed: () async {
                if (_feedbackController.text.isEmpty ||
                    _emailController.text.isEmpty) {
                  showSnackBar(
                      context,
                      _feedbackController.text.isEmpty
                          ? 'Please enter your feedback!'
                          : 'Please enter your email!');
                } else {
                  final Email email = Email(
                    body: _feedbackController.text,
                    subject: 'User Feedback',
                    recipients: ['khaledgomah@std.mans.edu.eg'],
                    isHTML: false, // النص عادي
                  );
                  try {
                    await FlutterEmailSender.send(email);
                    if (context.mounted) {
                      showSnackBar(context, 'Feedback sent successfully!');
                    }
                  } catch (error) {
                    if (context.mounted) {
                      showSnackBar(
                          context, 'Failed to send feedback, please try again');
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
