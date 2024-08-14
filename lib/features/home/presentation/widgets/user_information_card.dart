/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/auth/presentation/bloc/auth_bloc.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccessState) {
          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Nome: ${state.user.name}'),
                  subtitle: Text('Email: ${state.user.email}'),
                ),
                ListTile(
                  title: Text(
                      'Renda Fixa: R\$ ${state.user.fixedIncome.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
