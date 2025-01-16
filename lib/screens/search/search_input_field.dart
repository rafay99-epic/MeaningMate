import 'package:flutter/material.dart';

class SearchInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final Function(String) onSearch;
  final VoidCallback onClear;

  const SearchInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.onSearch,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onSubmitted: onSearch,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Search for a word...',
          hintStyle:
              TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          filled: true,
          fillColor: theme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 3),
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.black),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black),
                  onPressed: onClear,
                )
              : null,
        ),
      ),
    );
  }
}
