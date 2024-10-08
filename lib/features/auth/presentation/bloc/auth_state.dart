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

final class AuthUpdateFixedIncomeSuccessState extends AuthState {
  final UserEntity user;

  const AuthUpdateFixedIncomeSuccessState(this.user);
}

final class AuthUpdateAccountTypeSuccessState extends AuthState {
  final UserEntity user;

  const AuthUpdateAccountTypeSuccessState(this.user);
}

final class AuthPasswordRecoverSuccessState extends AuthState {}