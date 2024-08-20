/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/finance/domain/usecases/create_expense.dart';
import 'package:prism/features/finance/domain/usecases/remove_expense.dart';
import 'package:prism/features/finance/domain/usecases/update_expense.dart';
import 'package:prism/features/finance/domain/usecases/get_expenses.dart';
import 'package:prism/features/finance/domain/usecases/get_expense.dart';
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/core/enums/expense_category.dart';

part 'finance_event.dart';

part 'finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final CreateExpense _createExpense;
  final UpdateExpense _updateExpense;
  final RemoveExpense _removeExpense;
  final GetExpense _getExpense;
  final GetExpenses _getExpenses;

  FinanceBloc({
    required CreateExpense createExpense,
    required UpdateExpense updateExpense,
    required RemoveExpense removeExpense,
    required GetExpense getExpense,
    required GetExpenses getExpenses,
  })  : _createExpense = createExpense,
        _updateExpense = updateExpense,
        _removeExpense = removeExpense,
        _getExpense = getExpense,
        _getExpenses = getExpenses,
        super(FinanceInitialState()) {
    on<FinanceEvent>((_, emit) => emit(FinanceLoadingState()));
    on<FinanceCreateEvent>(_create);
    on<FinanceUpdateEvent>(_update);
    on<FinanceRemoveEvent>(_remove);
    on<FinanceLoadEvent>(_load);
    on<FinanceGetEvent>(_get);
  }

  void _create(
    FinanceCreateEvent event,
    Emitter<FinanceState> emit,
  ) async {
    final result = await _createExpense(
      CreateExpenseParams(
        userId: event.userId,
        title: event.title,
        amount: event.amount,
        date: event.date,
        category: event.category,
      ),
    );
    result.fold(
      (failure) => emit(FinanceErrorState(failure.message)),
      (expense) => emit(FinanceCreateSuccessState(expense)),
    );
  }

  void _update(
    FinanceUpdateEvent event,
    Emitter<FinanceState> emit,
  ) async {
    final result = await _updateExpense(
      UpdateExpenseParams(
        userId: event.userId,
        id: event.id,
        title: event.title,
        amount: event.amount,
        date: event.date,
        category: event.category,
      ),
    );
    result.fold(
      (failure) => emit(FinanceErrorState(failure.message)),
      (expense) => emit(FinanceUpdateSuccessState(expense)),
    );
  }

  void _remove(
    FinanceRemoveEvent event,
    Emitter<FinanceState> emit,
  ) async {
    final result = await _removeExpense(
      RemoveExpenseParams(
        userId: event.userId,
        id: event.id,
      ),
    );
    result.fold(
      (failure) => emit(FinanceErrorState(failure.message)),
      (expense) => emit(FinanceRemoveSuccessState()),
    );
  }

  void _load(
    FinanceLoadEvent event,
    Emitter<FinanceState> emit,
  ) async {
    final result = await _getExpenses(
      GetExpensesParams(
        userId: event.userId,
      ),
    );
    result.fold(
      (failure) => emit(FinanceErrorState(failure.message)),
      (expenses) => emit(FinanceSuccessState(expenses)),
    );
  }

  void _get(
    FinanceGetEvent event,
    Emitter<FinanceState> emit,
  ) async {
    final result = await _getExpense(
      GetExpenseParams(
        userId: event.userId,
        id: event.id,
      ),
    );
    result.fold(
      (failure) => emit(FinanceErrorState(failure.message)),
      (expense) => emit(FinanceCreateSuccessState(expense)),
    );
  }
}
