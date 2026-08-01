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

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.description,
                      color: Colors.blue,
                    ),
                    title: Text(doc.title),
                    subtitle: Text(doc.category),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Delete Document"),
                            content: const Text(
                              "Are you sure you want to delete this document?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              FilledButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await provider.deleteDocument(index);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Document deleted."),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddDocumentPage(),
            ),
          );

          if (context.mounted) {
            provider.loadDocuments();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}