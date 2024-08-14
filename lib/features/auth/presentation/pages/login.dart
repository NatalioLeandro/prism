/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/auth/presentation/widgets/redirect_link.dart';
import 'package:prism/features/auth/presentation/widgets/auth_title.dart';
import 'package:prism/features/auth/presentation/widgets/login_form.dart';
import 'package:prism/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prism/config/routes/router.dart' as routes;
import 'package:prism/core/utils/show_dialog.dart';
import 'package:prism/core/enums/alert_type.dart';
import 'package:prism/core/themes/palette.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthErrorState) {
              showMessageDialog(
                context,
                title: 'Ops...',
                message: state.message,
                type: AlertType.error,
                onConfirm: () {},
              );
            } else if (state is AuthSuccessState) {
              showMessageDialog(
                context,
                title: 'Sucesso!',
                message: 'Login efetuado com sucesso!',
                type: AlertType.success,
                onRedirect: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    routes.home,
                    (route) => false,
                  );
                },
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Palette.white),
                ),
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(height: 40),
                      const AuthTitle(title: 'Login'),
                      const SizedBox(height: 40),
                      const LoginForm(),
                      const SizedBox(height: 40),
                      RedirectLink(
                        text: 'Não tem uma conta?',
                        link: 'Registre-se',
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            routes.register,
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
