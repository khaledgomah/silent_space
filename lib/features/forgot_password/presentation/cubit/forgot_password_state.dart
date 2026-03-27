import 'package:equatable/equatable.dart';
import 'package:silent_space/features/forgot_password/domain/entities/forgot_password_entity.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordRequestSuccess extends ForgotPasswordState {
  final String message;

  const ForgotPasswordRequestSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ForgotPasswordVerifySuccess extends ForgotPasswordState {
  final ForgotPasswordEntity entity;

  const ForgotPasswordVerifySuccess({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class ForgotPasswordResetSuccess extends ForgotPasswordState {
  final String message;

  const ForgotPasswordResetSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String error;

  const ForgotPasswordFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
