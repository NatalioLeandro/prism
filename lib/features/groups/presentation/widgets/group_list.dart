/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/groups/presentation/widgets/group_list_view.dart';
import 'package:prism/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:prism/features/groups/domain/entities/group.dart';
import 'package:prism/core/common/cubit/user/user_cubit.dart';
import 'package:prism/config/routes/router.dart' as routes;
import 'package:prism/core/common/widgets/loader.dart';
import 'package:prism/core/enums/account_type.dart';
import 'package:prism/core/utils/show_dialog.dart';
import 'package:prism/core/enums/alert_type.dart';

class GroupList extends StatefulWidget {
  const GroupList({super.key});

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  List<GroupEntity> _allGroups = [];

  @override
  void initState() {
    super.initState();
    _loadAllGroups();
  }

  void _loadAllGroups() {
    context.read<GroupsBloc>().add(
          GroupsGetAllEvent(userId: context.read<UserCubit>().state.id),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _loadAllGroups();
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
            } else if (state is GroupsCreateSuccessState ||
                state is GroupsRemoveSuccessState ||
                state is GroupsAddMemberSuccessState) {
              _loadAllGroups();
            }
          },
          builder: (context, state) {
            if (state is GroupsLoadingState) {
              return const Loader();
            }

            if (state is GroupsSuccessState) {
              _allGroups = state.groups;
            }

            if (_allGroups.isEmpty) {
              return Center(
                child: Text(
                  'Você não está em nenhum grupo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              );
            }

            return GroupListView(groups: _allGroups);
          },
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 60.0,
            right: 20.0,
            child: FloatingActionButton(
              onPressed: () {
                final user = context.read<UserCubit>().state;
                final userType = user.account;
                if (userType == AccountType.free && _allGroups.length >= 3) {
                  showMessageDialog(
                    context,
                    title: 'Ops...',
                    message:
                        'Você atingiu o limite de grupos criados. Para criar mais grupos, faça um upgrade para a conta premium.',
                    type: AlertType.error,
                    onConfirm: () {},
                  );
                } else {
                  Navigator.of(context).pushNamed(
                    routes.createGroup,
                  );
                }
              },
              tooltip: 'Criar novo grupo',
              child: const Icon(Icons.add),
            ),
          ),
          Positioned(
            bottom: 1.0,
            right: 20.0,
            child: FloatingActionButton(
              heroTag: 'qr_scanner',
              onPressed: () {
                Navigator.of(context).pushNamed(
                  routes.scanner,
                );
              },
              child: const Icon(Icons.qr_code_scanner),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
