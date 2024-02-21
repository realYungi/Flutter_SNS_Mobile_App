import 'package:flutter/material.dart';

class MyDropdownBar extends StatelessWidget {
  final String? defaultValue;
  final List<String> options;
  final void Function(String?) onChanged;

  const MyDropdownBar({
    super.key,
    this.defaultValue,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Colors.white, // Default enabled border color
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: defaultValue,
            onChanged: onChanged,
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            dropdownColor: Colors.grey.shade200,
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
        ),
      ),
    );
  }
}
