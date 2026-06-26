import 'package:crop_survey/features/widgets/app_header.dart';
import 'package:crop_survey/screens/applications/widgets/farmer_info_card.dart';
import 'package:crop_survey/screens/applications/widgets/save_application_button.dart';
import 'package:crop_survey/screens/applications/widgets/summary_card.dart';
import 'package:crop_survey/screens/applications/widgets/survey_details_table.dart';
import 'package:flutter/material.dart';

class NewApplicationScreen extends StatelessWidget {
  const NewApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(
          title: "New Application",
          subtitle: "Create a new crop insurance application",
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FarmerInfoCard(),

                const SizedBox(height: 24),

                const SurveyDetailsTable(),

                const SizedBox(height: 24),

                const SummaryCard(),

                const SizedBox(height: 30),

                Align(
                  alignment: Alignment.centerRight,
                  child: SaveApplicationButton(
                    onPressed: () {
                      // Save implementation comes next
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
