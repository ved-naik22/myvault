import 'package:flutter/material.dart';

class RecentItems extends StatelessWidget {
  const RecentItems({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        leading: Icon(Icons.description),
        title: Text("No recent items"),
        subtitle: Text("Documents you open will appear here"),
      ),
    );
  }
}