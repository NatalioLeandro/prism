part of 'user_cubit.dart';

@immutable
sealed class UserState {}

class UserInitialState extends UserState {}

class UserLoggedInState extends UserState {
  final UserEntity user;

  UserLoggedInState(
    this.user,
  );
}

class UserAccountLoadingState extends UserState {}

class UserAccountLoadedState extends UserState {
  final AccountEntity account;

  UserAccountLoadedState(
    this.account,
  );
}

class UserAppThemeState extends UserState {
  final bool isDark;

  UserAppThemeState(
    this.isDark,
  );
}
