/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/auth/presentation/widgets/redirect_link.dart';
import 'package:prism/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prism/config/routes/router.dart' as routes;
import 'package:prism/core/common/widgets/form_field.dart';
import 'package:prism/core/common/widgets/button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomFormField(
            hint: 'Digite seu email',
            label: 'Email',
            icon: Icons.email_outlined,
            controller: _emailController,
          ),
          const SizedBox(height: 20),
          CustomFormField(
            hint: 'Digite sua senha',
            label: 'Senha',
            icon: Icons.lock_outline,
            controller: _passwordController,
            obscure: true,
          ),
          const SizedBox(height: 15),
          RedirectLink(
            text: '',
            link: 'Esqueceu a senha?',
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                routes.register,
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Entrar',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                      AuthLoginEvent(
                        email: _emailController.text,
                        password: _passwordController.text,
                      ),
                    );
              }
            },
          ),
        ],
      ),
    );
  }
}
