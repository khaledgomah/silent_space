part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  const SettingsLoaded({required this.categories});
  final List<String> categories;

  @override
  List<Object?> get props => [categories];
}

class SettingsError extends SettingsState {
  const SettingsError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
