/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/finance/presentation/widgets/finance_searchbar.dart';
import 'package:prism/features/finance/presentation/widgets/finance_card.dart';
import 'package:prism/features/finance/presentation/bloc/finance_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    _loadFinances();
  }

  void _loadFinances() {
    context.read<FinanceBloc>().add(
          FinanceLoadEvent(userId: context.read<UserCubit>().state.id),
        );
  }

  void _searchFinances(String query) {
    setState(() {
      _filteredFinances = _allFinances
          .where(
            (finance) =>
                finance.title.toLowerCase().contains(query.toLowerCase()) ||
                finance.category.name
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                Constants()
                    .categoryMap
                    .keys
                    .firstWhere(
                      (key) => Constants().categoryMap[key] == finance.category,
                      orElse: () => '',
                    )
                    .toLowerCase()
                    .contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<FinanceBloc, FinanceState>(
        listener: (context, state) {
          if (state is FinanceCreateSuccessState) {
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
        builder: (context, state) {
          if (state is FinanceLoadingState) {
            return const Center(
              child: Loader(),
            );
          } else if (state is FinanceSuccessState) {
            if (_allFinances.isEmpty) {
              _allFinances = state.finances;
              _filteredFinances = _allFinances;
            } else {
              _allFinances = state.finances;
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FinanceSearch(onSearch: _searchFinances),
                      ],
                    ),
                  ),
                  Wrap(
                    runSpacing: 5,
                    children: _filteredFinances
                        .map((expense) => FinanceCard(expense: expense))
                        .toList(),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Erro ao carregar finanças'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
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
