import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/sounds_manager.dart';
import 'package:silent_space/features/time/data/models/sound.dart';
import 'package:silent_space/features/time/presentation/manager/timer_cubit/timer_cubit.dart';
import 'package:silent_space/features/time/presentation/widgets/sound_tile.dart';

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
        name: AppStrings.none.tr(),
        icon: Icons.volume_off,
        path: SoundsManager.none,
      ),
      Sound(
        name: AppStrings.tide.tr(),
        icon: Icons.water,
        path: SoundsManager.tide,
      ),
      Sound(
        name: AppStrings.forest.tr(),
        icon: FontAwesomeIcons.tree,
        path: SoundsManager.forest,
      ),
      Sound(
        name: AppStrings.cafe.tr(),
        icon: Icons.local_cafe,
        path: SoundsManager.cafe,
      ),
      Sound(
        name: AppStrings.storm.tr(),
        icon: Icons.thunderstorm,
        path: SoundsManager.storm,
      ),
      Sound(
        name: AppStrings.clock.tr(),
        icon: FontAwesomeIcons.clock,
        path: SoundsManager.clock,
      ),
      Sound(
        name: AppStrings.bonfire.tr(),
        icon: FontAwesomeIcons.fire,
        path: SoundsManager.bonfire,
      ),
      Sound(
        name: AppStrings.books.tr(),
        icon: FontAwesomeIcons.bookOpen,
        path: SoundsManager.books,
      ),
      Sound(
        name: AppStrings.grass.tr(),
        icon: Icons.grass,
        path: SoundsManager.grass,
      ),
      Sound(
        name: AppStrings.mosque.tr(),
        icon: FontAwesomeIcons.mosque,
        path: SoundsManager.mosque,
      ),
      Sound(
        name: AppStrings.library.tr(),
        icon: Icons.account_balance,
        path: SoundsManager.library,
      ),
      Sound(
        name: AppStrings.stream.tr(),
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
              BlocProvider.of<TimerCubit>(context).setPath(sounds[index].path);
            });
          },
          sound: sounds[index],
        ),
      ),
    );
  }
}
