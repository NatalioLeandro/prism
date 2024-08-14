/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/auth/presentation/widgets/redirect_link.dart';
import 'package:prism/features/auth/presentation/widgets/register_form.dart';
import 'package:prism/features/auth/presentation/widgets/auth_title.dart';
import 'package:prism/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prism/config/routes/router.dart' as routes;
import 'package:prism/core/utils/show_dialog.dart';
import 'package:prism/core/enums/alert_type.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                message: 'Cadastro efetuado com sucesso!',
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
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.onPrimary),
                ),
              );
            }
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(height: 40),
                      const AuthTitle(title: 'Cadastro'),
                      const SizedBox(height: 40),
                      const RegisterForm(),
                      const SizedBox(height: 40),
                      RedirectLink(
                        text: 'Já tem uma conta?',
                        link: 'Faça login',
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            routes.login,
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
