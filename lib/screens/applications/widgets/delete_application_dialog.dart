import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeleteApplicationDialog extends StatefulWidget {
  final String farmerId;
  final String farmerName;

  const DeleteApplicationDialog({
    super.key,
    required this.farmerId,
    required this.farmerName,
  });

  @override
  State<DeleteApplicationDialog> createState() =>
      _DeleteApplicationDialogState();
}

class _DeleteApplicationDialogState
    extends State<DeleteApplicationDialog> {
  bool deleting = false;

  Future<void> deleteApplication() async {
    setState(() {
      deleting = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;

      final farmerRef = firestore
          .collection("farmers")
          .doc(widget.farmerId);

      //--------------------------------------------------
      // Delete survey details
      //--------------------------------------------------

      final surveySnapshot =
          await farmerRef
              .collection("surveyDetails")
              .get();

      final batch = firestore.batch();

      for (final doc in surveySnapshot.docs) {
        batch.delete(doc.reference);
      }

      //--------------------------------------------------
      // Delete farmer
      //--------------------------------------------------

      batch.delete(farmerRef);

      await batch.commit();

      if (!mounted) return;

      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "${widget.farmerName} deleted successfully.",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Application"),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
            size: 60,
          ),

          const SizedBox(height: 20),

          Text(
            "Delete application of\n${widget.farmerName}?",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "This action cannot be undone.",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed:
              deleting
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
          child: const Text("Cancel"),
        ),

        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed:
              deleting
                  ? null
                  : deleteApplication,
          icon: deleting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.delete),
          label: const Text("Delete"),
        ),
      ],
    );
  }
}