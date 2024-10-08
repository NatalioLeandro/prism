part of 'finance_bloc.dart';

@immutable
abstract class FinanceEvent {}

class FinanceLoadEvent extends FinanceEvent {
  final String userId;

  FinanceLoadEvent({
    required this.userId,
  });
}

class FinanceCreateEvent extends FinanceEvent {
  final String userId;
  final String title;
  final double amount;
  final String groupId;
  final DateTime date;
  final ExpenseCategory category;
  final ExpenseType type;

  FinanceCreateEvent({
    required this.userId,
    required this.title,
    required this.amount,
    required this.groupId,
    required this.date,
    required this.category,
    required this.type,
  });
}

class FinanceUpdateEvent extends FinanceEvent {
  final String userId;
  final String id;
  final String title;
  final double amount;
  final String groupId;
  final DateTime date;
  final ExpenseCategory category;
  final ExpenseType type;

  FinanceUpdateEvent({
    required this.userId,
    required this.id,
    required this.title,
    required this.amount,
    required this.groupId,
    required this.date,
    required this.category,
    required this.type,
  });
}

class FinanceRemoveEvent extends FinanceEvent {
  final String userId;
  final String id;

  FinanceRemoveEvent({
    required this.userId,
    required this.id,
  });
}

class FinanceGetEvent extends FinanceEvent {
  final String userId;
  final String id;

  FinanceGetEvent({
    required this.userId,
    required this.id,
  });
}
