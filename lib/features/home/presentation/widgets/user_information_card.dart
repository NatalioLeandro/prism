import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/common/entities/user.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({super.key});

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
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () {
                      _showEditIncomeDialog(context, state.user);
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is AuthUpdateFixedIncomeSuccessState) {
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
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () {
                      _showEditIncomeDialog(context, state.user);
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Column(
            children: [
              const SizedBox(height: 20),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  void _showEditIncomeDialog(BuildContext context, UserEntity user) {
    final TextEditingController incomeController = TextEditingController(
      text: user.fixedIncome.toStringAsFixed(2),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Renda Fixa'),
          content: TextField(
            controller: incomeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Nova Renda Fixa',
              prefixText: 'R\$ ',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newIncome = double.tryParse(incomeController.text);
                if (newIncome != null) {
                  BlocProvider.of<AuthBloc>(context).add(
                    UpdateUserFixedIncomeEvent(
                      userId: user.id,
                      newFixedIncome: newIncome,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Salvar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
