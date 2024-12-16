import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/constans.dart';
import 'package:silent_space/features/time/data/models/sound.dart';

class SoundTile extends StatelessWidget {
  final Sound sound;
  final Function() onPressed;
  final bool isSelected;
  const SoundTile(
      {super.key,
      required this.sound,
      required this.onPressed,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      isSelected: isSelected,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
            isSelected ? Constants.secondaryColor : Colors.transparent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
      onPressed: onPressed,
      icon: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(sound.icon),
            const SizedBox(height: 8),
            Text(sound.name),
          ],
        ),
      ),
    );
  }
}
