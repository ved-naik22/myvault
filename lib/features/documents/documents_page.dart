import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/document_provider.dart';
import 'widgets/empty_documents.dart';
import 'add_document_page.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DocumentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Documents"),
      ),
      body: provider.documents.isEmpty
          ? const EmptyDocuments()
          : ListView.builder(
              itemCount: provider.documents.length,
              itemBuilder: (context, index) {
                final doc = provider.documents[index];

                return ListTile(
                  leading: const Icon(Icons.description),
                  title: Text(doc.title),
                  subtitle: Text(doc.category),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddDocumentPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}