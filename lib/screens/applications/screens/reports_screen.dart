import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_survey/features/widgets/app_header.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() =>
      _ReportsScreenState();
}

class _ReportsScreenState
    extends State<ReportsScreen> {

  bool loading = true;

  int applications = 0;
  int farmers = 0;

  int pending = 0;
  int approved = 0;
  int rejected = 0;

  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    loadReport();
  }

  Future<void> loadReport() async {

    loading = true;

    setState(() {});

    final snapshot =
        await FirebaseFirestore.instance
            .collection("farmers")
            .get();

    applications = snapshot.docs.length;

    farmers = snapshot.docs.length;

    pending = 0;
    approved = 0;
    rejected = 0;

    totalAmount = 0;

    for (final doc in snapshot.docs) {

      final data = doc.data();

      switch (data["status"] ?? "Pending") {

        case "Approved":
          approved++;
          break;

        case "Rejected":
          rejected++;
          break;

        default:
          pending++;
      }

      totalAmount +=
          (data["totalAmount"] ?? 0)
              .toDouble();
    }

    loading = false;

    setState(() {});
  }

  Widget reportCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {

    return Card(

      elevation: 2,

      child: Container(

        width: 220,

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            CircleAvatar(

              backgroundColor:
                  color.withOpacity(.1),

              child: Icon(
                icon,
                color: color,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              value,
              style:
                  const TextStyle(
                fontSize: 30,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(title),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        const AppHeader(

          title: "Reports",

          subtitle:
              "Application Statistics",
        ),

        Expanded(

          child: loading

              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )

              : SingleChildScrollView(

                  padding:
                      const EdgeInsets.all(24),

                  child: Wrap(

                    spacing: 20,

                    runSpacing: 20,

                    children: [

                      reportCard(
                        "Applications",
                        "$applications",
                        Colors.blue,
                        Icons.description,
                      ),

                      reportCard(
                        "Farmers",
                        "$farmers",
                        Colors.green,
                        Icons.people,
                      ),

                      reportCard(
                        "Pending",
                        "$pending",
                        Colors.orange,
                        Icons.pending,
                      ),

                      reportCard(
                        "Approved",
                        "$approved",
                        Colors.green,
                        Icons.check_circle,
                      ),

                      reportCard(
                        "Rejected",
                        "$rejected",
                        Colors.red,
                        Icons.cancel,
                      ),

                      reportCard(
                        "Insurance Amount",
                        "₹${totalAmount.toStringAsFixed(0)}",
                        Colors.purple,
                        Icons.currency_rupee,
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}