import 'package:flutter/material.dart';

/* custom snackbar to display in widget */
showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.blue,
      content: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: Colors.yellow),
      ),
      duration: const Duration(seconds: 5),
    ),
  );
}
