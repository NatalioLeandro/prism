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

class PasswordRecoverForm extends StatefulWidget {
  const PasswordRecoverForm({super.key});

  @override
  State<PasswordRecoverForm> createState() => _PasswordRecoverForm();
}

class _PasswordRecoverForm extends State<PasswordRecoverForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
          const SizedBox(height: 15),
          RedirectLink(
            text: '',
            link: 'voltar',
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                routes.login,
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 15),
          CustomButton(
            text: 'Enviar',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                      AuthPasswordRecoverEvent(
                        email: _emailController.text,
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
