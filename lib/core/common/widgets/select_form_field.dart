/* Flutter Imports */
import 'package:flutter/material.dart';

class CustomSelectFormField extends StatefulWidget {
  final String hint;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String>? onChanged;

  const CustomSelectFormField({
    super.key,
    required this.hint,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<CustomSelectFormField> createState() => _CustomSelectFormFieldState();
}

class _CustomSelectFormFieldState extends State<CustomSelectFormField> {
  @override
  Widget build(BuildContext context) {
    final currentValue = widget.options.contains(widget.selectedValue)
        ? widget.selectedValue
        : widget.options.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.hint,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          value: currentValue,
          hint: Text(
            widget.hint,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          items: widget.options.toSet().map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(
                option,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              widget.onChanged!(value!);
            });
          },
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}
