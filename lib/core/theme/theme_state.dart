part of 'theme_cubit.dart';

@immutable
class ThemeState extends Equatable {
  final bool isDark;

  const ThemeState({required this.isDark});

  @override
  List<Object?> get props => [isDark];
}
