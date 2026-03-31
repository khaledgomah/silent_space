part of 'theme_cubit.dart';

@immutable
class ThemeState extends Equatable {
  const ThemeState({required this.isDark});
  final bool isDark;

  @override
  List<Object?> get props => [isDark];
}
