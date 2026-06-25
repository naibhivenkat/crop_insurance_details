import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateFormat(
      "dd MMM yyyy, EEEE",
    ).format(DateTime.now());

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xffE5E7EB),
          ),
        ),
      ),
      child: Row(
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle ?? now,
                  style: TextStyle(
                    color:
                        Colors.grey.shade700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 320,
            height: 45,
            child: TextField(
              decoration: InputDecoration(
                hintText:
                    "Search application...",
                prefixIcon: const Icon(
                  Icons.search,
                ),
                filled: true,
                fillColor:
                    Colors.grey.shade100,
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          if (actions != null)
            ...actions!,

          const SizedBox(width: 20),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: const Row(
              children: [

                CircleAvatar(
                  radius: 18,
                  child: Icon(
                    Icons.person,
                    size: 20,
                  ),
                ),

                SizedBox(width: 10),

                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Administrator",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    Text(
                      "Logged In",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}