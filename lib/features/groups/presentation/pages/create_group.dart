/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/groups/presentation/widgets/group_form.dart';
import 'package:prism/features/home/presentation/widgets/menu_button.dart';
import 'package:prism/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:prism/features/home/presentation/widgets/app_header.dart';
import 'package:prism/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prism/core/common/cubit/theme/theme_cubit.dart';
import 'package:prism/core/common/cubit/user/user_cubit.dart';
import 'package:prism/core/utils/show_dialog.dart';
import 'package:prism/core/enums/alert_type.dart';
import 'package:prism/core/themes/theme.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
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
        automaticallyImplyLeading: false,
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
      body: BlocConsumer<GroupsBloc, GroupsState>(
        listener: (context, state) {
          if (state is GroupsErrorState) {
            showMessageDialog(
              context,
              title: 'Ops...',
              message: state.message,
              type: AlertType.error,
              onConfirm: () {},
            );
          } else if (state is GroupsCreateSuccessState) {
            showMessageDialog(
              context,
              title: 'Sucesso!',
              message: 'Grupo criado com sucesso!',
              type: AlertType.success,
              onRedirect: () {
                Navigator.pop(context);
              },
            );
          }
        },
        builder: (context, state) {
          return const Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: GroupForm(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Criar novo grupo',
        child: const Icon(Icons.list),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: BottomAppBar(
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: const CircularNotchedRectangle(),
          child: Container(height: 50.0),
        ),
      ),
    );
  }
}
