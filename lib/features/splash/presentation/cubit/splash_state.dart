import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class Authenticated extends SplashState {}

class Unauthenticated extends SplashState {}

class SplashError extends SplashState {
  const SplashError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
