/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/finance/presentation/widgets/finance_searchbar.dart';
import 'package:prism/features/finance/presentation/widgets/finance_card.dart';
import 'package:prism/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:prism/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/core/common/cubit/user/user_cubit.dart';
import 'package:prism/config/routes/router.dart' as routes;
import 'package:prism/core/common/widgets/loader.dart';
import 'package:prism/core/constants/constants.dart';
import 'package:prism/core/utils/show_dialog.dart';
import 'package:prism/core/enums/alert_type.dart';

class FinanceListGrid extends StatefulWidget {
  const FinanceListGrid({super.key});

  @override
  State<FinanceListGrid> createState() => _FinanceListGridState();
}

class _FinanceListGridState extends State<FinanceListGrid> {
  List<ExpenseEntity> _filteredFinances = [];
  List<ExpenseEntity> _allFinances = [];
  Map<String, String> _groupMap = {};

  @override
  void initState() {
    super.initState();
    _loadFinances();
    _loadGroups();
  }

  Future<void> _loadFinances() async {
    context.read<FinanceBloc>().add(
      FinanceLoadEvent(userId: context
          .read<UserCubit>()
          .state
          .id),
    );
  }

  void _loadGroups() {
    context.read<GroupsBloc>().add(
      GroupsGetAllEvent(userId: context
          .read<UserCubit>()
          .state
          .id),
    );
  }

  void _searchFinances(String query) {
    setState(() {
      _filteredFinances = _allFinances.where((finance) {
        final queryLower = query.toLowerCase();

        final matchesText = finance.title.toLowerCase().contains(queryLower) ||
            finance.category.name.toLowerCase().contains(queryLower) ||
            Constants()
                .categoryMap
                .keys
                .firstWhere(
                  (key) => Constants().categoryMap[key] == finance.category,
              orElse: () => '',
            )
                .toLowerCase()
                .contains(queryLower) ||
            finance.type.name.toLowerCase().contains(queryLower) ||
            Constants()
                .typeMap
                .keys
                .firstWhere(
                  (key) => Constants().typeMap[key] == finance.type,
              orElse: () => '',
            )
                .toLowerCase()
                .contains(queryLower);

        final matchesValue = double.tryParse(query) != null &&
            finance.amount.toString().contains(query);

        final matchesDate = _formatDate(finance.date).contains(query);

        return matchesText || matchesValue || matchesDate;
      }).toList();
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString()
        .padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<FinanceBloc, FinanceState>(
            listener: (context, state) {
              if (state is FinanceCreateSuccessState) {
                _loadFinances();
              } else if (state is FinanceRemoveSuccessState) {
                _loadFinances();
              } else if (state is FinanceErrorState) {
                showMessageDialog(
                  context,
                  title: 'Ops...',
                  message: state.message,
                  type: AlertType.error,
                  onConfirm: () {},
                );
              }
            },
          ),
          BlocListener<GroupsBloc, GroupsState>(
            listener: (context, state) {
              if (state is GroupsSuccessState) {
                setState(() {
                  _groupMap = {
                    for (var group in state.groups) group.id: group.name
                  };
                });
              }
            },
          ),
        ],
        child: BlocBuilder<FinanceBloc, FinanceState>(
          builder: (context, state) {
            if (state is FinanceLoadingState) {
              return const Center(
                child: Loader(),
              );
            } else if (state is FinanceSuccessState) {
              if (_allFinances.isEmpty) {
                _allFinances = state.finances
                  ..sort((a, b) => b.date.compareTo(a.date));
                _filteredFinances = _allFinances;
              } else if (_allFinances.length != state.finances.length) {
                _allFinances = state.finances
                  ..sort((a, b) => b.date.compareTo(a.date));
                _filteredFinances = _allFinances;
              }

              return RefreshIndicator(
                onRefresh: _loadFinances,
                color: Theme
                    .of(context)
                    .colorScheme
                    .secondary,
                backgroundColor: Theme
                    .of(context)
                    .colorScheme
                    .primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FinanceSearch(onSearch: _searchFinances),
                      ),
                      _filteredFinances.isEmpty
                          ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Nenhuma finança encontrada.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .onPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                          : Wrap(
                        runSpacing: 5,
                        children: _filteredFinances
                            .map(
                              (expense) =>
                              FinanceCard(
                                expense: expense,
                                groupMap: _groupMap,
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
                        )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('Erro ao carregar finanças'),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'create_finance',
        onPressed: () {
          Navigator.of(context).pushNamed(
            routes.createFinance,
          );
        },
        tooltip: 'Criar nova finança',
        child: const Icon(Icons.add),
      ),
    );
  }
}