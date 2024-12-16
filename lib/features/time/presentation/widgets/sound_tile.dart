import 'package:flutter/material.dart';
import 'package:silent_space/features/time/data/models/sound.dart';
import 'package:silent_space/features/time/presentation/widgets/select_music_modal_sheet.dart';

class SoundTile extends StatelessWidget {
  final Sound sound;
  const SoundTile({super.key, required this.sound});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(sound.icon),
        Text(sound.name),
      ],
    );
  }
}
