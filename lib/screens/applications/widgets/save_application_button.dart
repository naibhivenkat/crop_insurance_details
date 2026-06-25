import 'package:flutter/material.dart';

class SaveApplicationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool loading;

  const SaveApplicationButton({
    super.key,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: loading ? null : onPressed,
      icon: loading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.save),
      label: Text(
        loading
            ? "Saving..."
            : "Save Application",
      ),
      style: FilledButton.styleFrom(
        minimumSize: const Size(220, 50),
      ),
    );
  }
}