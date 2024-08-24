import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/common/entities/user.dart';
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/features/finance/presentation/widgets/finance_card.dart';
import 'package:prism/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:prism/features/groups/domain/entities/group.dart';
import 'package:prism/core/common/widgets/loader.dart';
import 'package:prism/core/utils/show_dialog.dart';
import 'package:prism/core/enums/alert_type.dart';
import 'package:prism/features/groups/presentation/widgets/group_member_card.dart';
import 'package:prism/features/finance/presentation/bloc/finance_bloc.dart';

import 'package:prism/core/common/cubit/user/user_cubit.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
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
          } else if (state is GroupsGetMembersSuccessState) {
            setState(() {
              members = state.members;
            });
          } else if (state is GroupsGetExpensesSuccessState) {
            setState(() {
              expenses = state.expenses;
            });
          }
        },
        builder: (context, state) {
          if (state is GroupsLoadingState) {
            return const Loader();
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.group.description),
                const SizedBox(height: 16),
                const Text('Membros:'),
                members.isNotEmpty
                    ? Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: members.map((member) {
                          return MemberCard(member: member);
                        }).toList(),
                      )
                    : const Center(child: Text('Nenhum membro adicionado.')),
                const SizedBox(height: 16),
                const Text('Despesas:'),
                expenses.isNotEmpty
                    ? Wrap(
                        runSpacing: 5,
                        children: expenses.map((expense) {
                          return SizedBox(
                            width: (MediaQuery.of(context).size.width / 2) - 16,
                            child: FinanceCard(
                              expense: expense,
                              groupMap: groupMap,
                              onDelete: () {
                                context.read<FinanceBloc>().add(
                                  FinanceRemoveEvent(
                                    userId:
                                    context.read<UserCubit>().state.id,
                                    id: expense.id,
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      )
                    : const Center(child: Text('Nenhuma despesa registrada.')),
              ],
            ),
          );
        },
      ),
    );
  }
}
