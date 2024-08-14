/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/home/presentation/widgets/navigation_bar.dart';
import 'package:prism/features/home/presentation/widgets/menu_button.dart';
import 'package:prism/features/home/presentation/widgets/app_header.dart';
import 'package:prism/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prism/core/common/cubit/theme/theme_cubit.dart';
import 'package:prism/core/common/cubit/user/user_cubit.dart';
import 'package:prism/config/routes/router.dart' as routes;
import 'package:prism/core/utils/show_dialog.dart';
import 'package:prism/core/enums/alert_type.dart';
import 'package:prism/core/themes/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  final _balanceController = TextEditingController();

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showLogoutConfirmation(BuildContext context) {
    showMessageDialog(
      context,
      title: 'Confirmação de Logout',
      message: 'Você tem certeza que deseja sair?',
      type: AlertType.warning,
      onConfirm: () {
        context.read<UserCubit>().update(null);
        context.read<AuthBloc>().add(AuthLogoutEvent());
      },
      onDismiss: () {},
    );
  }

  void _switchTheme() {
    final currentTheme = context.read<ThemeCubit>().state;
    ThemeData newTheme;

    if (currentTheme is ThemeChangedState) {
      newTheme = currentTheme.themeData.brightness == Brightness.light
          ? CustomTheme.dark
          : CustomTheme.light;
    } else {
      newTheme = CustomTheme.dark;
    }

    context.read<ThemeCubit>().update(newTheme);
  }

  void _updateFixedIncome() {
    final userState = context.read<UserCubit>().state;
    final newFixedIncome = double.tryParse(_balanceController.text);
    if (newFixedIncome != null) {
      context.read<AuthBloc>().add(UpdateUserFixedIncomeEvent(
        userId: userState.id,
        newFixedIncome: newFixedIncome,
      ));
    } else {
      showMessageDialog(
        context,
        title: 'Erro',
        message: 'O valor do saldo deve ser um número válido.',
        type: AlertType.error,
        onConfirm: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const AppHeader(),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          actions: [
            MenuButton(
                onLogout: () => _showLogoutConfirmation(context),
                onThemeSwitch: _switchTheme),
          ],
          toolbarHeight: 80,
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthInitialState) {
              Navigator.pushReplacementNamed(context, routes.login);
            } else if (state is AuthErrorState) {
              showMessageDialog(
                context,
                title: 'Ops...',
                message: state.message,
                type: AlertType.error,
                onConfirm: () {},
              );
            }
          },
          child: IndexedStack(
            index: _currentIndex,
            children: [
              const Center(child: Text('Grupos')),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Card para Atualização de Saldo
                    Card(
                      margin: const EdgeInsets.all(16.0),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Atualizar Saldo',
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _balanceController,
                              decoration: const InputDecoration(
                                labelText: 'Novo Saldo',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _updateFixedIncome,
                              child: const Text('Atualizar Saldo'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Home Page Content Here'),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('FixedIncomes Page Content Here'),
                    // widget para exibir os saldos
                    const SizedBox(height: 20),
                    Card(
                      margin: const EdgeInsets.all(16.0),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                if (state is AuthSuccessState) {
                                  return Text(
                                    '${state.user.fixedIncome}',
                                    style: const TextStyle(fontSize: 14),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomNavigationBar(
          onDestinationSelected: _onTabTapped,
          selectedIndex: _currentIndex,
        ));
  }
}
