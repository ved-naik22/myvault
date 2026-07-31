import 'package:flutter/material.dart';

class AddDocumentPage extends StatelessWidget {
  const AddDocumentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Document"),
      ),
      body: const Center(
        child: Text(
          "Add Document Screen",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}