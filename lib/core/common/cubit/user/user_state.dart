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