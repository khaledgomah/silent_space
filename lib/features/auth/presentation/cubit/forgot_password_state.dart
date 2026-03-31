import 'package:equatable/equatable.dart';
import 'package:silent_space/features/auth/domain/entities/forgot_password_entity.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordRequestSuccess extends ForgotPasswordState {
  const ForgotPasswordRequestSuccess({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

class ForgotPasswordVerifySuccess extends ForgotPasswordState {
  const ForgotPasswordVerifySuccess({required this.entity});
  final ForgotPasswordEntity entity;

  @override
  List<Object?> get props => [entity];
}

class ForgotPasswordResetSuccess extends ForgotPasswordState {
  const ForgotPasswordResetSuccess({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

class ForgotPasswordFailure extends ForgotPasswordState {
  const ForgotPasswordFailure({required this.error});
  final String error;

  @override
  List<Object?> get props => [error];
}
