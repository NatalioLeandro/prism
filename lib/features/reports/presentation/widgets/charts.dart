/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/* Project Imports */
import 'package:prism/features/reports/presentation/widgets/overtime_expenses_chart.dart';
import 'package:prism/features/reports/presentation/widgets/categories_bar_chart.dart';
import 'package:prism/features/reports/presentation/widgets/categories_chart.dart';
import 'package:prism/features/finance/presentation/bloc/finance_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if (state is FinanceLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FinanceSuccessState) {
          final now = DateTime.now();
          final month = DateFormat('MMM')
              .format(now);
          final year = now.year;

          categoryData = _calculateCategoryData(state.finances, month, year);
          monthlyExpenses = _calculateMonthlyExpenses(state.finances, year);

          return Column(
            children: [
              PieChartCategories(
                categoryData: categoryData,
                colors: Constants().categoryColorMap,
                categories: Constants().categoryMap,
              ),
              BarChartExpensesOverTime(monthlyExpenses: monthlyExpenses),
              BarChartCategories(
                categoryData: categoryData,
                colors: Constants().categoryColorMap,
                categories: Constants().categoryMap,
              ),
            ],
          );
        } else {
          return const Center(child: Text('Erro ao carregar dados.'));
        }
      },
    );
  }

  Map<ExpenseCategory, double> _calculateCategoryData(
      List<ExpenseEntity> expenses, String month, int year) {
    final Map<ExpenseCategory, double> categoryData = {};

    for (var expense in expenses) {
      final expenseDate = expense.date;
      if (expenseDate.year == year &&
          DateFormat('MMM').format(expenseDate) == month) {
        final category = expense.category;
        if (categoryData.containsKey(category)) {
          categoryData[category] = categoryData[category]! + expense.amount;
        } else {
          categoryData[category] = expense.amount;
        }
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
        if (monthlyExpenses.containsKey(monthName)) {
          monthlyExpenses[monthName] =
              monthlyExpenses[monthName]! + expense.amount;
        } else {
          monthlyExpenses[monthName] = expense.amount;
        }
      }
    }

    final allMonths = DateFormat('MMM').format(DateTime(year, 1)).split(' ')
      ..addAll(DateFormat('MMM').format(DateTime(year, 12)).split(' '));
    for (var month in allMonths) {
      if (!monthlyExpenses.containsKey(month)) {
        monthlyExpenses[month] = 0.0;
      }
    }

    return monthlyExpenses;
  }
}
