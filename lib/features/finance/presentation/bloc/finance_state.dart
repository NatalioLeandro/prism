part of 'finance_bloc.dart';

@immutable
abstract class FinanceState {
  const FinanceState();
}

class FinanceInitialState extends FinanceState {}

class FinanceLoadingState extends FinanceState {}

class FinanceErrorState extends FinanceState {
  final String message;

  const FinanceErrorState(this.message);
}

class FinanceSuccessState extends FinanceState {
  final List<ExpenseEntity> finances;

  const FinanceSuccessState(this.finances);
}

class FinanceCreateSuccessState extends FinanceState {
  final ExpenseEntity finance;

  const FinanceCreateSuccessState(this.finance);
}

class FinanceUpdateSuccessState extends FinanceState {
  final ExpenseEntity finance;

  const FinanceUpdateSuccessState(this.finance);
}

class FinanceRemoveSuccessState extends FinanceState {}
