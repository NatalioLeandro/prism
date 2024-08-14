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

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _photoUrlController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomFormField(
            hint: 'Digite seu nome',
            label: 'Nome',
            icon: Icons.person_outline,
            controller: _nameController,
          ),
          const SizedBox(height: 15),
          CustomFormField(
            hint: 'Digite seu email',
            label: 'Email',
            icon: Icons.email_outlined,
            controller: _emailController,
          ),
          // const SizedBox(height: 15),
          // CustomFormField(
          //   hint: 'Digite sua foto',
          //   label: 'Foto',
          //   icon: Icons.photo_outlined,
          //   controller: _photoUrlController,
          // ),
          const SizedBox(height: 15),
          CustomFormField(
            hint: 'Digite sua senha',
            label: 'Senha',
            icon: Icons.lock_outline,
            controller: _passwordController,
            obscure: true,
          ),
          const SizedBox(height: 15),
          CustomButton(
            text: 'Cadastrar',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                      AuthRegisterEvent(
                        name: _nameController.text,
                        email: _emailController.text,
                        photo: _photoUrlController.text = 'default',
                        password: _passwordController.text,
                      ),
                    );
              }
            },
          ),
          const SizedBox(height: 10),
          RedirectLink(
            text: 'Ao continuar, você concorda com nossos',
            link: 'termos de uso.',
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
    );
  }
}
