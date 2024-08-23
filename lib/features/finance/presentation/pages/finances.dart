/* Flutter Imports */
import 'package:flutter/material.dart';

/* Project Imports */
import 'package:prism/features/finance/presentation/widgets/finance_list_grid.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FinanceListGrid(),
    );
  }
}
