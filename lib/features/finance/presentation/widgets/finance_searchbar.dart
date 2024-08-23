import 'package:flutter/material.dart';

class FinanceSearch extends StatefulWidget {
  final Function(String query) onSearch;

  const FinanceSearch({super.key, required this.onSearch});

  @override
  State<FinanceSearch> createState() => _FinanceSearchState();
}

class _FinanceSearchState extends State<FinanceSearch> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: const InputDecoration(
        labelText: 'Pesquisar Despesa',
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: widget.onSearch,
    );
  }
}
