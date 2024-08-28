/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:prism/core/enums/expense_category.dart';
import 'package:prism/core/enums/expense_type.dart';

class Constants {
  static const connectionError = 'Sem conexão com a internet.';
  static const unexpectedError = 'Ocorreu um erro inesperado.';

  final Map<String, Color> monthColors = {
    "Jan": const Color(0xFF004B23),
    "Fev": const Color(0xFF006400),
    "Mar": const Color(0xFF007200),
    "Abr": const Color(0xFF008000),
    "Mai": const Color(0xFF38B000),
    "Jun": const Color(0xFF70E000),
    "Jul": const Color(0xFF9EF01A),
    "Ago": const Color(0xFFCCFF33),
    "Set": const Color(0xFFB5E7A0),
    "Out": const Color(0xFF81C784),
    "Nov": const Color(0xFF4CAF50),
    "Dez": const Color(0xFF2E7D32),
  };

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
