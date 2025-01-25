import 'package:flutter/material.dart';

Widget buildInputArea(
  TextEditingController controller,
  FocusNode focusNode,
  VoidCallback onSendMessage,
  BuildContext context,
) {
  return Container(
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
    color: Theme.of(context).colorScheme.surface,
    child: Row(
      children: [
        Expanded(
          child: TextField(
            focusNode: focusNode,
            controller: controller,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: "Type your message...",
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            onSubmitted: (_) => onSendMessage(),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: onSendMessage,
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0,
            mini: false,
            child: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ),
      ],
    ),
  );
}
