import 'package:flutter/material.dart';


class EmailInputField extends StatefulWidget {
  final TextEditingController controller;
  final List<String> domainOptions;
  final String selectedDomain;
  final Function(String) onDomainChanged;

  const EmailInputField({
    Key? key,
    required this.controller,
    required this.domainOptions,
    required this.selectedDomain,
    required this.onDomainChanged,
  }) : super(key: key);

  @override
  _EmailInputFieldState createState() => _EmailInputFieldState();
}

class _EmailInputFieldState extends State<EmailInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: "Your Email", // Change "Email" to your desired label
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text("@"), // No need for "@" here
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: widget.selectedDomain,
                  onChanged: (newValue) {
                    setState(() {
                      widget.onDomainChanged(newValue!);
                    });
                  },
                  items: widget.domainOptions.map((domain) {
                    return DropdownMenuItem<String>(
                      value: domain,
                      child: Text(domain),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
