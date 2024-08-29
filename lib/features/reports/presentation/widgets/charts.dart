/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/* Project Imports */
import 'package:prism/features/reports/presentation/widgets/overtime_expenses_chart.dart';
import 'package:prism/features/reports/presentation/widgets/categories_bar_chart.dart';
import 'package:prism/features/reports/presentation/widgets/categories_chart.dart';
import 'package:prism/features/reports/presentation/widgets/income_chart.dart';
import 'package:prism/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:prism/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/core/common/cubit/user/user_cubit.dart';
import 'package:prism/core/enums/expense_category.dart';
import 'package:prism/core/constants/constants.dart';

class Charts extends StatefulWidget {
  const Charts({super.key});

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  Map<ExpenseCategory, double> categoryData = {};
  Map<String, double> monthlyExpenses = {};
  double? fixedIncome;

  @override
  void initState() {
    super.initState();
    _loadFinances();
  }

  void _loadFinances() {
    final userId = context.read<UserCubit>().state.id;
    context.read<FinanceBloc>().add(FinanceLoadEvent(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthSuccessState) {
          fixedIncome = authState.user.fixedIncome;

          return BlocBuilder<FinanceBloc, FinanceState>(
            builder: (context, financeState) {
              if (financeState is FinanceLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (financeState is FinanceSuccessState) {
                _prepareChartData(financeState.finances);

                return _buildCharts();
              } else {
                return const Center(
                  child: Text(
                    'Erro ao carregar dados.',
                  ),
                );
              }
            },
          );
        } else if (authState is AuthUpdateFixedIncomeSuccessState) {
          fixedIncome = authState.user.fixedIncome;

          return BlocBuilder<FinanceBloc, FinanceState>(
            builder: (context, financeState) {
              if (financeState is FinanceLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (financeState is FinanceSuccessState) {
                _prepareChartData(financeState.finances);

                return _buildCharts();
              } else {
                return const Center(
                  child: Text(
                    'Erro ao carregar dados.',
                  ),
                );
              }
            },
          );
        } else {
          return const Center();
        }
      },
    );
  }

  void _prepareChartData(List<ExpenseEntity> finances) {
    final now = DateTime.now();
    final month = DateFormat('MMM').format(now);
    final year = now.year;

    categoryData = _calculateCategoryData(finances, month, year);
    monthlyExpenses = _calculateMonthlyExpenses(finances, year);
  }

  Widget _buildCharts() {
    final hasCategoryData = categoryData.isNotEmpty;
    final hasMonthlyExpenses =
        monthlyExpenses.values.any((element) => element > 0);

    if (hasCategoryData && hasMonthlyExpenses) {
      return Column(
        children: [
          FixedIncomeVsExpensesChart(
            categoryData: categoryData,
            fixedIncome: fixedIncome ?? 0.0,
          ),
          PieChartCategories(
            categoryData: categoryData,
            colors: Constants().categoryColorMap,
            categories: Constants().categoryMap,
          ),
          BarChartExpensesOverTime(
            monthlyExpenses: monthlyExpenses,
          ),
          BarChartCategories(
            categoryData: categoryData,
            colors: Constants().categoryColorMap,
            categories: Constants().categoryMap,
          ),
        ],
      );
    } else {
      return const Center(
        heightFactor: 2,
        child: Text(
          'Sem dados para exibir.',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      );
    }
  }

  Map<ExpenseCategory, double> _calculateCategoryData(
      List<ExpenseEntity> expenses, String month, int year) {
    final Map<ExpenseCategory, double> categoryData = {};

    for (var expense in expenses) {
      final expenseDate = expense.date;
      if (expenseDate.year == year &&
          DateFormat('MMM').format(expenseDate) == month) {
        final category = expense.category;
        categoryData.update(category, (value) => value + expense.amount,
            ifAbsent: () => expense.amount);
      }
    }
    return categoryData;
  }

  Map<String, double> _calculateMonthlyExpenses(
      List<ExpenseEntity> expenses, int year) {
    final Map<String, double> monthlyExpenses = {};

    for (var expense in expenses) {
      final expenseDate = expense.date;
      if (expenseDate.year == year) {
        final monthName = DateFormat('MMM').format(expenseDate);
        monthlyExpenses.update(monthName, (value) => value + expense.amount,
            ifAbsent: () => expense.amount);
      }
    }

    _ensureAllMonthsArePresent(monthlyExpenses, year);

    return monthlyExpenses;
  }

  void _ensureAllMonthsArePresent(
      Map<String, double> monthlyExpenses, int year) {
    final allMonths = List.generate(
        12, (index) => DateFormat('MMM').format(DateTime(year, index + 1)));

    for (var month in allMonths) {
      monthlyExpenses.putIfAbsent(month, () => 0.0);
    }
  }
}
