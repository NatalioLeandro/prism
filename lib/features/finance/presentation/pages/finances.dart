/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:prism/features/finance/presentation/widgets/finance_form.dart';
// import 'package:prism/features/finance/presentation/widgets/finance_list.dart';
import 'package:prism/features/finance/presentation/widgets/finance_list_grid.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(5.0),
      child: FinanceListGrid(),
    );
  }
}
