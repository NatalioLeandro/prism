/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:prism/core/enums/expense_category.dart';
import 'package:prism/core/enums/expense_type.dart';

class Constants {
  static const connectionError = 'Sem conexão com a internet.';
  static const unexpectedError = 'Ocorreu um erro inesperado.';

  final Map<String, ExpenseCategory> categoryMap = {
    'Alimentação': ExpenseCategory.food,
    'Transporte': ExpenseCategory.transport,
    'Compras': ExpenseCategory.shopping,
    'Saúde': ExpenseCategory.health,
    'Educação': ExpenseCategory.education,
    'Outros': ExpenseCategory.others,
  };

  final Map<String, Color> categoryColorMap = {
    'Alimentação': const Color(0xFFE57373),
    'Transporte': const Color(0xFF81C784),
    'Compras': const Color(0xFF64B5F6),
    'Saúde': const Color(0xFF9575CD),
    'Educação': const Color(0xFF4DB6AC),
    'Outros': const Color(0xFFA1887F),
  };

  final Map<String, ExpenseType> typeMap = {
    'Fixa': ExpenseType.fixed,
    'Variável': ExpenseType.variable,
  };

  final Map<ExpenseType, Color> typeColorMap = {
    ExpenseType.fixed: const Color(0xFF4CAF50),
    ExpenseType.variable: const Color(0xFFE57373),
  };
}
