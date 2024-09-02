/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prism/core/common/entities/user.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccessState) {
          final user = (state).user;
          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Renda Fixa: R\$ ${user.fixedIncome.toStringAsFixed(2)}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () {
                      _showEditIncomeDialog(context, user);
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
                  title: Text(
                    'Renda Fixa: R\$ ${state.user.fixedIncome.toStringAsFixed(2)}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () {
                      _showEditIncomeDialog(context, (state).user);
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
                  Theme.of(context).colorScheme.secondary,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'Editar Renda Fixa',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          content: Container(
            height: 80,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: TextField(
                controller: incomeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nova Renda Fixa',
                  prefixText: 'R\$ ',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                elevation: WidgetStateProperty.all<double>(0),
              ),
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
