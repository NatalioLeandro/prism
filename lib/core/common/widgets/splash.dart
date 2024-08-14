/* Flutter Imports */
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prism/config/routes/router.dart' as routes;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 2), () {
      final authBloc = BlocProvider.of<AuthBloc>(context);
      authBloc.add(AuthIsLoggedInEvent());
      _authSubscription = authBloc.stream.listen((state) {
        if (state is AuthSuccessState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            routes.home,
            (route) => false,
          );
        } else if (state is AuthErrorState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            routes.login,
            (route) => false,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 15),
            Text(
              'PRISM',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Column(
              children: [
                Text(
                  'from',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Hurricane Softwares',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
