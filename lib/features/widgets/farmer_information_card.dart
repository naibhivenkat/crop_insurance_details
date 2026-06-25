import 'package:flutter/material.dart';

class FarmerInformationCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController mobileController;

  final DateTime selectedDate;

  final VoidCallback onSelectDate;

  const FarmerInformationCard({
    super.key,
    required this.nameController,
    required this.addressController,
    required this.mobileController,
    required this.selectedDate,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              "Farmer Information",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(
                      labelText: "Name",
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: TextFormField(
                    controller:
                        mobileController,
                    keyboardType:
                        TextInputType.phone,
                    decoration:
                        const InputDecoration(
                      labelText:
                          "Mobile Number",
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller:
                  addressController,
              maxLines: 3,
              decoration:
                  const InputDecoration(
                labelText: "Address",
              ),
            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: onSelectDate,
              child: InputDecorator(
                decoration:
                    const InputDecoration(
                  labelText: "Survey Date",
                ),
                child: Text(
                  "${selectedDate.day.toString().padLeft(2, '0')}-"
                  "${selectedDate.month.toString().padLeft(2, '0')}-"
                  "${selectedDate.year}",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}