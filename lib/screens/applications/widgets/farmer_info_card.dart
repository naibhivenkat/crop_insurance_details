import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FarmerInfoCard extends StatefulWidget {
  const FarmerInfoCard({super.key});

  @override
  State<FarmerInfoCard> createState() => _FarmerInfoCardState();
}

class _FarmerInfoCardState extends State<FarmerInfoCard> {
  final nameController = TextEditingController();

  final addressController = TextEditingController();

  final mobileController = TextEditingController();

  final ackController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  String status = "Pending";

  @override
  void dispose() {
    nameController.dispose();

    addressController.dispose();

    mobileController.dispose();

    ackController.dispose();

    super.dispose();
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2050),
      initialDate: selectedDate,
    );

    if (picked == null) return;

    setState(() {
      selectedDate = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Farmer Information",

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Application No",

                      border: OutlineInputBorder(),
                    ),

                    readOnly: true,

                    controller: TextEditingController(text: "Auto Generated"),
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: TextField(
                    controller: nameController,

                    decoration: const InputDecoration(
                      labelText: "Farmer Name",

                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              controller: addressController,

              maxLines: 2,

              decoration: const InputDecoration(
                labelText: "Address",

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: mobileController,

                    keyboardType: TextInputType.phone,

                    decoration: const InputDecoration(
                      labelText: "Mobile Number",

                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: InkWell(
                    onTap: pickDate,

                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Date",

                        border: OutlineInputBorder(),
                      ),

                      child: Text(
                        DateFormat("dd-MM-yyyy").format(selectedDate),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ackController,

                    decoration: const InputDecoration(
                      labelText: "Acknowledgement No",

                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: status,

                    decoration: const InputDecoration(
                      labelText: "Status",

                      border: OutlineInputBorder(),
                    ),

                    items: const [
                      DropdownMenuItem(
                        value: "Pending",
                        child: Text("Pending"),
                      ),

                      DropdownMenuItem(
                        value: "Submitted",
                        child: Text("Submitted"),
                      ),

                      DropdownMenuItem(
                        value: "Approved",
                        child: Text("Approved"),
                      ),

                      DropdownMenuItem(
                        value: "Rejected",
                        child: Text("Rejected"),
                      ),

                      DropdownMenuItem(
                        value: "Payment Released",

                        child: Text("Payment Released"),
                      ),
                    ],

                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        status = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
