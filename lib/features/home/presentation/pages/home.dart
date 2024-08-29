/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/home/presentation/widgets/user_information_card.dart';
import 'package:prism/features/home/presentation/widgets/navigation_bar.dart';
import 'package:prism/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:prism/features/home/presentation/widgets/menu_button.dart';
import 'package:prism/features/home/presentation/widgets/app_header.dart';
import 'package:prism/features/finance/presentation/pages/finances.dart';
import 'package:prism/features/reports/presentation/widgets/charts.dart';
import 'package:prism/features/groups/presentation/pages/groups.dart';
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

  @override
  void initState() {
    super.initState();
    _loadFinances();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _loadFinances() async {
    context.read<FinanceBloc>().add(
          FinanceLoadEvent(userId: context.read<UserCubit>().state.id),
        );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showMessageDialog(
      context,
      title: 'Confirmação de Saída',
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
            const Center(child: GroupPage()),
            RefreshIndicator(
              onRefresh: _loadFinances,
              color: Theme.of(context).colorScheme.secondary,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        UserInfoCard(),
                        Charts(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Center(
              child: FinancePage(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        onDestinationSelected: _onTabTapped,
        selectedIndex: _currentIndex,
      ),
    );
  }
}
