import 'package:crop_survey/screens/applications/screens/all_applications_screen.dart';
import 'package:crop_survey/screens/applications/screens/crop_rates_screen.dart';
import 'package:crop_survey/screens/applications/screens/export_screen.dart';
import 'package:crop_survey/screens/applications/screens/reports_screen.dart';

import 'package:crop_survey/screens/applications/screens/search_screen.dart';
import 'package:crop_survey/screens/applications/screens/settings_screen.dart';
import 'package:crop_survey/screens/applications/screens/update_status_screen.dart';
import 'package:crop_survey/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

import '../screens/survey/survey_form_screen.dart';



class AppRouter {
  static Route<dynamic> generateRoute(
      RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );

      case "/dashboard":
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );

      case "/new":
        return MaterialPageRoute(
          builder: (_) =>
              const SurveyFormScreen(),
        );

      case "/search":
        return MaterialPageRoute(
          builder: (_) =>
              const SearchScreen(),
        );

      case "/status":
        return MaterialPageRoute(
          builder: (_) =>
              const AllApplicationsScreen(),
        );

      case "/reports":
        return MaterialPageRoute(
          builder: (_) =>
              const ReportsScreen(),
        );

      case "/crop-rates":
        return MaterialPageRoute(
          builder: (_) =>
              const CropRatesScreen(),
        );

      case "/settings":
        return MaterialPageRoute(
          builder: (_) =>
              const SettingsScreen(),
        );

      case "/export":
        return MaterialPageRoute(
          builder: (_) =>
              const ExportScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                "Route not found : ${settings.name}",
              ),
            ),
          ),
        );
    }
  }
}

