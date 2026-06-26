import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
Widget build(BuildContext context) {
  return SizedBox(
    width: 300,
    height: 150,
    child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                Row(
                  children: [

                    CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          color..withValues(alpha: 0.15),
                      child: Icon(
                        icon,
                        color: color,
                        size: 20,
                      ),
                    ),

                    const Spacer(),

                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),

                const Spacer(),

                Align(
                  alignment:
                      Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Align(
                  alignment:
                      Alignment.centerLeft,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          Colors.grey.shade700,
                      fontSize: 14,
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