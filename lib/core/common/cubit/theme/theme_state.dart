part of 'theme_cubit.dart';

@immutable
sealed class ThemeState {}

class ThemeInitialState extends ThemeState {}

class ThemeChangedState extends ThemeState {
  final ThemeData themeData;

  ThemeChangedState(this.themeData);
}
