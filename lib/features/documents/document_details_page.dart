import 'dart:io';

import 'package:flutter/material.dart';

import 'add_document_page.dart';
import 'document_preview_page.dart';
import 'models/document_model.dart';

class DocumentDetailsPage extends StatelessWidget {
  final DocumentModel document;
  final int documentIndex;

  const DocumentDetailsPage({
    super.key,
    required this.document,
    required this.documentIndex,
  });

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  String _getFileName(String path) {
    return path.split(Platform.pathSeparator).last;
  }

  IconData _getFileIcon(String path) {
    final extension = path.toLowerCase();

    if (extension.endsWith(".pdf")) {
      return Icons.picture_as_pdf;
    }

    if (extension.endsWith(".jpg") ||
        extension.endsWith(".jpeg") ||
        extension.endsWith(".png")) {
      return Icons.image;
    }

    return Icons.insert_drive_file;
  }

  Future<void> _openDocument(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentPreviewPage(
          title: document.title,
          filePath: document.filePath,
        ),
      ),
    );
  }

  Future<void> _editDocument(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddDocumentPage(
          document: document,
          documentIndex: documentIndex,
        ),
      ),
    );

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _deleteDocument(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Document"),
        content: const Text(
          "Are you sure you want to delete this document?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final fileName = _getFileName(document.filePath);
    final fileIcon = _getFileIcon(document.filePath);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Document Details"),
        actions: [
          IconButton(
            tooltip: "Edit",
            icon: const Icon(Icons.edit),
            onPressed: () => _editDocument(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Document Icon
          Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                fileIcon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Center(
            child: Text(
              document.title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),

          const SizedBox(height: 8),

          // Category
          Center(
            child: Chip(
              avatar: const Icon(
                Icons.category,
                size: 18,
              ),
              label: Text(document.category),
            ),
          ),

          const SizedBox(height: 25),

          // Information Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    "Document Information",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 18),

                  _InfoRow(
                    icon: Icons.category,
                    label: "Category",
                    value: document.category,
                  ),

                  const Divider(height: 24),

                  _InfoRow(
                    icon: Icons.calendar_today,
                    label: "Date Added",
                    value: _formatDate(document.createdAt),
                  ),

                  const Divider(height: 24),

                  _InfoRow(
                    icon: fileIcon,
                    label: "File",
                    value: fileName,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Notes
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    "Notes",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    document.notes.trim().isEmpty
                        ? "No notes added."
                        : document.notes,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Open Document
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _openDocument(context),
              icon: const Icon(Icons.open_in_new),
              label: const Text("Open Document"),
            ),
          ),

          const SizedBox(height: 12),

          // Edit
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _editDocument(context),
              icon: const Icon(Icons.edit),
              label: const Text("Edit Document"),
            ),
          ),

          const SizedBox(height: 12),

          // Delete
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => _deleteDocument(context),
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              label: const Text(
                "Delete Document",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 22,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}