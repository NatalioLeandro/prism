/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/auth/domain/usecases/user_register.dart';
import 'package:prism/features/auth/domain/usecases/current_user.dart';
import 'package:prism/features/auth/domain/usecases/user_logout.dart';
import 'package:prism/features/auth/domain/usecases/user_login.dart';
import 'package:prism/core/common/cubit/user/user_cubit.dart';
import 'package:prism/core/common/entities/user.dart';
import 'package:prism/core/usecase/usecase.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRegister _userRegister;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final UserLogout _userLogout;
  final UserCubit _userCubit;

  AuthBloc({
    required UserRegister userRegister,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required UserLogout userLogout,
    required UserCubit userCubit,
  })  : _userRegister = userRegister,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _userLogout = userLogout,
        _userCubit = userCubit,
        super(AuthInitialState()) {
    on<AuthEvent>((_, emit) => emit(AuthLoadingState()));
    on<AuthLoginEvent>(_login);
    on<AuthRegisterEvent>(_register);
    on<AuthIsLoggedInEvent>(_isLoggedIn);
    on<AuthLogoutEvent>(_logout);
  }

  void _isLoggedIn(
    AuthIsLoggedInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _currentUser(NoParams());
    response.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (user) => _emitAuthSuccessState(user, emit),
    );
  }

  void _login(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final response = await _userLogin(
        LoginParams(
          email: event.email,
          password: event.password,
        ),
      );
      response.fold(
        (failure) => emit(AuthErrorState(failure.message)),
        (user) => _emitAuthSuccessState(user, emit),
      );
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  void _register(
    AuthRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final response = await _userRegister(
        RegisterParams(
          email: event.email,
          name: event.name,
          photo: event.photo,
          password: event.password,
        ),
      );
      response.fold(
        (failure) => emit(AuthErrorState(failure.message)),
        (user) => _emitAuthSuccessState(user, emit),
      );
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  void _logout(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _userLogout(NoParams());
    response.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (_) {
        _userCubit.update(null);
        emit(AuthInitialState());
      },
    );
  }

  void _emitAuthSuccessState(
    UserEntity user,
    Emitter<AuthState> emit,
  ) {
    if (state is! AuthSuccessState ||
        (state as AuthSuccessState).user != user) {
      _userCubit.update(user);
      emit(AuthSuccessState(user));
    }
  }
}
