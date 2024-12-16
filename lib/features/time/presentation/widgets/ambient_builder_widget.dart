import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silent_space/features/time/data/models/sound.dart';
import 'package:silent_space/features/time/presentation/widgets/sound_tile.dart';
import 'package:silent_space/generated/l10n.dart';

class AmbientBuilderWidget extends StatefulWidget {
  const AmbientBuilderWidget({
    super.key,
  });

  @override
  State<AmbientBuilderWidget> createState() => _AmbientBuilderWidgetState();
}

class _AmbientBuilderWidgetState extends State<AmbientBuilderWidget> {
  int selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final List<Sound> sounds = [
      Sound(
        name: S.of(context).none,
        icon: Icons.volume_off,
      ),
      Sound(
        name: S.of(context).tide,
        icon: Icons.water,
      ),
      Sound(
        name: S.of(context).forest,
        icon: FontAwesomeIcons.tree,
      ),
      Sound(
        name: S.of(context).cafe,
        icon: Icons.local_cafe,
      ),
      Sound(
        name: S.of(context).storm,
        icon: Icons.thunderstorm,
      ),
      Sound(
        name: S.of(context).clock,
        icon: FontAwesomeIcons.clock,
      ),
      Sound(
        name: S.of(context).bonfire,
        icon: FontAwesomeIcons.fire,
      ),
      Sound(
        name: S.of(context).books,
        icon: FontAwesomeIcons.bookOpen,
      ),
      Sound(
        name: S.of(context).grass,
        icon: Icons.grass,
      ),
      Sound(
        name: S.of(context).mosque,
        icon: FontAwesomeIcons.mosque,
      ),
      Sound(
        name: S.of(context).library,
        icon: Icons.account_balance,
      ),
      Sound(
        name: S.of(context).stream,
        icon: Icons.water_drop,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      itemCount: sounds.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (context, index) => FittedBox(
        child: SoundTile(
          isSelected: selectedIndex == index,
          onPressed: () {
            setState(() {
              selectedIndex = index;
            });
          },
          sound: sounds[index],
        ),
      ),
    );
  }
}
