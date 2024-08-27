/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

/* Project Imports */
import 'package:prism/features/groups/presentation/widgets/group_member_card.dart';
import 'package:prism/features/finance/presentation/widgets/finance_card.dart';
import 'package:prism/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:prism/features/home/presentation/widgets/menu_button.dart';
import 'package:prism/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:prism/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/features/groups/domain/entities/group.dart';
import 'package:prism/core/common/cubit/theme/theme_cubit.dart';
import 'package:prism/core/common/cubit/user/user_cubit.dart';
import 'package:prism/core/common/widgets/loader.dart';
import 'package:prism/core/common/entities/user.dart';
import 'package:prism/core/utils/drawn_divider.dart';
import 'package:prism/core/utils/show_dialog.dart';
import 'package:prism/core/enums/alert_type.dart';
import 'package:prism/core/themes/theme.dart';

class GroupDetailPage extends StatefulWidget {
  final GroupEntity group;

  const GroupDetailPage({
    super.key,
    required this.group,
  });

  @override
  State<GroupDetailPage> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetailPage> {
  List<UserEntity> members = [];
  List<ExpenseEntity> expenses = [];
  late Map<String, String> groupMap;

  @override
  void initState() {
    super.initState();
    _loadGroupDetails();
    groupMap = {widget.group.id: widget.group.name};
  }

  void _loadGroupDetails() {
    context.read<GroupsBloc>().add(GroupsGetMembersEvent(
          userId: context.read<UserCubit>().state.id,
          id: widget.group.id,
        ));
    context.read<GroupsBloc>().add(GroupsGetExpensesEvent(
          userId: context.read<UserCubit>().state.id,
          id: widget.group.id,
        ));
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

  void _showDeleteGroupConfirmation() {
    showMessageDialog(
      context,
      title: 'Excluir Grupo',
      message:
          'Você tem certeza que deseja excluir o grupo? Essa ação não pode ser desfeita.',
      type: AlertType.warning,
      onConfirm: () {
        context.read<GroupsBloc>().add(GroupsRemoveEvent(
              userId: context.read<UserCubit>().state.id,
              id: widget.group.id,
            ));
        Navigator.pop(context);
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
    final isOwner = context.read<UserCubit>().state.id == widget.group.owner;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.group.name.toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
            letterSpacing: 1.5,
          ),
        ),
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
      body: RefreshIndicator(
        onRefresh: () async {
          _loadGroupDetails();
        },
        color: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: BlocConsumer<GroupsBloc, GroupsState>(
          listener: (context, state) {
            if (state is GroupsErrorState) {
              showMessageDialog(
                context,
                title: 'Ops...',
                message: state.message,
                type: AlertType.error,
                onConfirm: () {},
              );
            } else if (state is GroupsGetMembersSuccessState) {
              setState(() {
                members = state.members;
              });
            } else if (state is GroupsGetExpensesSuccessState) {
              setState(() {
                expenses = state.expenses;
              });
            } else if (state is GroupsAddMemberSuccessState) {
              _loadGroupDetails();
            }
          },
          builder: (context, state) {
            if (state is GroupsLoadingState) {
              return const Loader();
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                widget.group.description[0].toUpperCase() +
                                    widget.group.description.substring(1),
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          QrImageView(
                            data: '${widget.group.id}|${widget.group.owner}',
                            version: QrVersions.auto,
                            size: 150.0,
                            eyeStyle: QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            dataModuleStyle: QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    dividerWithText('Proprietário'),
                    const SizedBox(height: 10),
                    if (members.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MemberCard(member: members.firstWhere((member) {
                            return member.id == widget.group.owner;
                          })),
                          if (isOwner)
                            Padding(
                              padding: const EdgeInsets.all(3),
                              child: ElevatedButton.icon(
                                onPressed: _showDeleteGroupConfirmation,
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                label: const Text('Excluir Grupo'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      )
                    else
                      const Center(
                        child: Text('Nenhum administrador encontrado.'),
                      ),
                    const SizedBox(height: 10),
                    dividerWithText('Membros'),
                    const SizedBox(height: 10),
                    members.isNotEmpty
                        ? Wrap(
                            spacing: 5.0,
                            runSpacing: 5.0,
                            children: members.map((member) {
                              return MemberCard(member: member);
                            }).toList(),
                          )
                        : const Center(
                            child: Text('Nenhum membro adicionado.'),
                          ),
                    const SizedBox(height: 10),
                    dividerWithText('Despesas'),
                    const SizedBox(height: 10),
                    expenses.isNotEmpty
                        ? Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: expenses.map((expense) {
                              return SizedBox(
                                width: (MediaQuery.of(context).size.width / 2) -
                                    16,
                                child: FinanceCard(
                                  expense: expense,
                                  groupMap: groupMap,
                                  onDelete: () {
                                    context.read<FinanceBloc>().add(
                                          FinanceRemoveEvent(
                                            userId: context
                                                .read<UserCubit>()
                                                .state
                                                .id,
                                            id: expense.id,
                                          ),
                                        );
                                  },
                                ),
                              );
                            }).toList(),
                          )
                        : const Center(
                            child: Text('Nenhuma despesa registrada.'),
                          ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'back_to_groups',
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
