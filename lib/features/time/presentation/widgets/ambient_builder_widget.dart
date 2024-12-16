import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silent_space/features/time/data/models/sound.dart';
import 'package:silent_space/features/time/presentation/widgets/select_music_modal_sheet.dart';
import 'package:silent_space/features/time/presentation/widgets/sound_tile.dart';
import 'package:silent_space/generated/l10n.dart';

class AmbientBuilderWidget extends StatelessWidget {
  const AmbientBuilderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
   final List<Sound> sounds = [
      Sound(
        name: S.of(context).none,
        icon: Icons.volume_off,
        isSelected: false,
      ),
      Sound(
        name: S.of(context).tide,
        icon: Icons.water,
        isSelected: false,
      ),
      Sound(
        name: S.of(context).forest,
        icon: FontAwesomeIcons.tree,
        isSelected: false,
      ),
      Sound(
        name: S.of(context).cafe,
        icon: Icons.local_cafe,
        isSelected: false,
      ),
      Sound(
        name: S.of(context).storm,
        icon: Icons.thunderstorm,
        isSelected: false,
      ),
      Sound(
        name: S.of(context).clock,
        icon: FontAwesomeIcons.clock,
        isSelected: false,
      ),
      Sound(
          name: S.of(context).bonfire,
          icon: FontAwesomeIcons.fire,
          isSelected: false),
      Sound(
        name: S.of(context).books,
        icon: FontAwesomeIcons.bookOpen,
        isSelected: false,
      ),
      Sound(
        name: S.of(context).grass,
        icon: Icons.grass,
        isSelected: false,
      ),
      Sound(
        name: S.of(context).mosque,
        icon: FontAwesomeIcons.mosque,
        isSelected: false,
      ),
      Sound(
        name: S.of(context).library,
        icon: Icons.account_balance,
        isSelected: false,
      ),
      Sound(
        name: S.of(context).stream,
        icon: Icons.water_drop,
        isSelected: false,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      itemCount: sounds.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) => SoundTile(
        sound: sounds[index],
      ),
    );
  }
}
