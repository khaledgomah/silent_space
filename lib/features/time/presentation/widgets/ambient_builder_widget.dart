import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silent_space/features/time/presentation/manager/timer_cubit/timer_cubit.dart';
import 'package:silent_space/features/time/data/models/sound.dart';
import 'package:silent_space/features/time/presentation/widgets/sound_tile.dart';
import 'package:silent_space/generated/l10n.dart';
import 'package:silent_space/core/utils/sounds_manager.dart';

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
        path: SoundsManager.none,
      ),
      Sound(
        name: S.of(context).tide,
        icon: Icons.water,
        path: SoundsManager.tide,
      ),
      Sound(
        name: S.of(context).forest,
        icon: FontAwesomeIcons.tree,
        path: SoundsManager.forest,
      ),
      Sound(
        name: S.of(context).cafe,
        icon: Icons.local_cafe,
        path: SoundsManager.cafe,
      ),
      Sound(
        name: S.of(context).storm,
        icon: Icons.thunderstorm,
        path: SoundsManager.storm,
      ),
      Sound(
        name: S.of(context).clock,
        icon: FontAwesomeIcons.clock,
        path: SoundsManager.clock,
      ),
      Sound(
        name: S.of(context).bonfire,
        icon: FontAwesomeIcons.fire,
        path: SoundsManager.bonfire,
      ),
      Sound(
        name: S.of(context).books,
        icon: FontAwesomeIcons.bookOpen,
        path: SoundsManager.books,
      ),
      Sound(
        name: S.of(context).grass,
        icon: Icons.grass,
        path: SoundsManager.grass,
      ),
      Sound(
        name: S.of(context).mosque,
        icon: FontAwesomeIcons.mosque,
        path: SoundsManager.mosque,
      ),
      Sound(
        name: S.of(context).library,
        icon: Icons.account_balance,
        path: SoundsManager.library,
      ),
      Sound(
        name: S.of(context).stream,
        icon: Icons.water_drop,
        path: SoundsManager.stream,
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
              BlocProvider.of<TimerCubit>(context).path = sounds[index].path;
            });
          },
          sound: sounds[index],
        ),
      ),
    );
  }
}
