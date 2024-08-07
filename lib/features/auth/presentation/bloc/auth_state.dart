part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitialState extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState(this.message);
}

final class AuthSuccessState extends AuthState {
  final UserEntity user;

  const AuthSuccessState(this.user);
}