/* Flutter Imports */
import 'package:flutter/material.dart';

/* Project Imports */
// import 'package:prism/features/transaction/presentation/pages/create.dart';
// import 'package:prism/features/transaction/presentation/pages/home.dart';
import 'package:prism/features/auth/presentation/pages/register.dart';
import 'package:prism/features/auth/presentation/pages/login.dart';
import 'package:prism/core/common/widgets/splash.dart';

const String splash = '/';
const String home = '/home';
const String login = '/login';
const String register = '/register';
const String transaction = '/transaction';

Route controller(RouteSettings settings) {
  switch (settings.name) {
    case splash:
      return MaterialPageRoute(
        builder: (_) => const SplashPage(),
      );
    // case home:
    //   return MaterialPageRoute(
    //     builder: (_) => const HomePage(),
    //   );
    case login:
      return MaterialPageRoute(
        builder: (_) => const LoginPage(),
      );
    case register:
      return MaterialPageRoute(
        builder: (_) => const RegisterPage(),
      );
    // case transaction:
    //   return MaterialPageRoute(
    //     builder: (_) => const CreateTransactionPage(),
    //   );
    default:
      return MaterialPageRoute(
        builder: (_) => const LoginPage(),
      );
  }
}
