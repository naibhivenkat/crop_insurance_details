
import 'package:flutter/material.dart';

enum AppMenu {
  dashboard,
  newApplication,
  searchApplication,
  updateStatus,
  cropRates,
  reports,
  export,
  settings,
}

class AppSidebar extends StatelessWidget {
  final AppMenu selected;
  final ValueChanged<AppMenu> onSelected;

  const AppSidebar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Colors.white,
      child: SizedBox(
        width: 260,
        child: Column(
          children: [
            const SizedBox(height: 24),

            const CircleAvatar(
              radius: 34,
              backgroundColor: Color(0xffE8F5E9),
              child: Icon(
                Icons.agriculture,
                color: Colors.green,
                size: 38,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Crop Survey",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              "Management System",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                children: [

                  _menuTile(
                    icon: Icons.dashboard_rounded,
                    title: "Dashboard",
                    menu: AppMenu.dashboard,
                  ),

                  _menuTile(
                    icon: Icons.add_circle_outline,
                    title: "New Application",
                    menu: AppMenu.newApplication,
                  ),

                  _menuTile(
                    icon: Icons.search,
                    title: "Search",
                    menu: AppMenu.searchApplication,
                  ),

                  _menuTile(
                    icon: Icons.assignment_turned_in_outlined,
                    title: "Update Status",
                    menu: AppMenu.updateStatus,
                  ),

                  _menuTile(
                    icon: Icons.grass,
                    title: "Crop Rates",
                    menu: AppMenu.cropRates,
                  ),

                  _menuTile(
                    icon: Icons.bar_chart,
                    title: "Reports",
                    menu: AppMenu.reports,
                  ),

                  _menuTile(
                    icon: Icons.file_download_outlined,
                    title: "Export Excel",
                    menu: AppMenu.export,
                  ),

                  _menuTile(
                    icon: Icons.settings_outlined,
                    title: "Settings",
                    menu: AppMenu.settings,
                  ),
                ],
              ),
            ),

            const Divider(),

            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Version 1.0.0",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required AppMenu menu,
  }) {
    final bool active = selected == menu;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Material(
        color: active
            ? const Color(0xffE8F5E9)
            : Colors.transparent,
        borderRadius:
            BorderRadius.circular(12),
        child: InkWell(
          borderRadius:
              BorderRadius.circular(12),
          onTap: () => onSelected(menu),
          child: Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: active
                      ? Colors.green
                      : Colors.grey.shade700,
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: active
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: active
                          ? Colors.green
                          : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}