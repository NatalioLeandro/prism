/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
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
  int _currentIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PRISM',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 5),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthSuccessState) {
                  return Text(
                    'Olá, ${state.user.name}',
                    style: const TextStyle(fontSize: 14),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_outlined),
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutConfirmation(context);
              } else if (value == 'theme') {
                _switchTheme();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app_outlined),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'theme',
                child: Row(
                  children: [
                    Icon(Icons.brightness_6_outlined),
                    SizedBox(width: 8),
                    Text('Alternar Tema'),
                  ],
                ),
              ),
            ],
          ),
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
          children: const [
            Center(child: Text('Home')),
            Center(child: Text('Grupos')),
            Center(child: Text('Finanças')),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: NavigationBar(
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.group_outlined),
              label: 'Grupos',
            ),
            NavigationDestination(
              icon: Icon(Icons.monetization_on_outlined),
              label: 'Finanças',
            ),
          ],
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabTapped,
        ),
      ),
    );
  }
}
