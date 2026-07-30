import 'package:flutter/material.dart';

import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_summary.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/recent_items.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyVault"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            DashboardHeader(),

            SizedBox(height: 20),

            DashboardSummary(),

            SizedBox(height: 30),

            Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 15),

            QuickActionsGrid(),

            SizedBox(height: 30),

            Text(
              "Recent Items",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 15),

            RecentItems(),
          ],
        ),
      ),
    );
  }
}