import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final bool isSaving;

  final VoidCallback? onPressed;

  final String text;

  const SaveButton({
    super.key,
    required this.isSaving,
    required this.onPressed,
    this.text = "Save Survey",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton.icon(
        onPressed: isSaving ? null : onPressed,

        icon: isSaving
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
          isSaving ? "Saving..." : text,
        ),
      ),
    );
  }
}