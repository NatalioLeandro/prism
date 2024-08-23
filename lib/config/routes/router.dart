/* Flutter Imports */
import 'package:flutter/material.dart';

/* Project Imports */
import 'package:prism/features/finance/presentation/pages/create_finance.dart';
import 'package:prism/features/auth/presentation/pages/password_recover.dart';
import 'package:prism/features/auth/presentation/pages/register.dart';
import 'package:prism/features/auth/presentation/pages/login.dart';
import 'package:prism/features/home/presentation/pages/home.dart';
import 'package:prism/core/common/widgets/splash.dart';

const String splash = '/';
const String home = '/home';
const String login = '/login';
const String register = '/register';
const String transaction = '/transaction';
const String createFinance = '/create-finance';
const String passwordRecover = '/password-recover';

Route controller(RouteSettings settings) {
  switch (settings.name) {
    case splash:
      return MaterialPageRoute(
        builder: (_) => const SplashPage(),
      );
    case login:
      return MaterialPageRoute(
        builder: (_) => const LoginPage(),
      );
    case register:
      return MaterialPageRoute(
        builder: (_) => const RegisterPage(),
      );
    case passwordRecover:
      return MaterialPageRoute(
        builder: (_) => const PasswordRecoverPage(),
      );
    case createFinance:
      return MaterialPageRoute(
        builder: (_) => const CreateFinancePage(),
      );
    case home:
      return MaterialPageRoute(
        builder: (_) => const HomePage(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => const LoginPage(),
      );
  }
}
