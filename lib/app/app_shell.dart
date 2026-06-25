import 'package:crop_survey/features/widgets/app_sidebar.dart';

import 'package:crop_survey/screens/applications/screens/crop_rates_screen.dart';
import 'package:crop_survey/screens/applications/screens/export_screen.dart';
import 'package:crop_survey/screens/applications/screens/reports_screen.dart';
import 'package:crop_survey/screens/applications/screens/search_screen.dart';

import 'package:crop_survey/screens/applications/screens/settings_screen.dart';
import 'package:crop_survey/screens/applications/screens/update_status_screen.dart';
import 'package:crop_survey/screens/dashboard/dashboard_screen.dart';
import 'package:crop_survey/screens/survey/survey_form_screen.dart';
import 'package:flutter/material.dart';



class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppMenu selectedMenu = AppMenu.dashboard;

  Widget _currentPage() {
    switch (selectedMenu) {
      case AppMenu.dashboard:
        return const DashboardScreen();

      case AppMenu.newApplication:
        return const SurveyFormScreen();

      case AppMenu.searchApplication:
        return const SearchScreen();

      case AppMenu.updateStatus:
        return const UpdateStatusScreen();

      case AppMenu.cropRates:
        return const CropRatesScreen();

      case AppMenu.reports:
        return const ReportsScreen();

      case AppMenu.export:
        return const ExportScreen();

      case AppMenu.settings:
        return const SettingsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: SafeArea(
        child: Row(
          children: [
            AppSidebar(
              selected: selectedMenu,
              onSelected: (menu) {
                setState(() {
                  selectedMenu = menu;
                });
              },
            ),

            Expanded(
              child: _currentPage(),
            ),
          ],
        ),
      ),
    );
  }
}