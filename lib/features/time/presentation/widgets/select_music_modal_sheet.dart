import 'package:flutter/material.dart';
import 'package:silent_space/core/helper/extentions.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';
import 'package:silent_space/features/time/presentation/widgets/ambient_builder_widget.dart';
import 'package:silent_space/generated/l10n.dart';

class SelectMusicSheet extends StatelessWidget {
  const SelectMusicSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: context.height() * 0.5,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  enableFeedback: false,
                  onPressed: () {},
                  icon: const Text(''),
                ),
                Text(
                  S.of(context).ambientSound,
                  style: TextStyleManager.bodyText1,
                ),
                IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const AmbientBuilderWidget()
          ],
        ),
      ),
    );
  }
}
