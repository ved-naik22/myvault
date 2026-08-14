import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_document_page.dart';
import 'document_preview_page.dart';
import 'models/document_model.dart';
import 'providers/document_provider.dart';

class DocumentDetailsPage extends StatelessWidget {
  final DocumentModel document;
  final int documentIndex;

  const DocumentDetailsPage({
    super.key,
    required this.document,
    required this.documentIndex,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _getFileName(String path) {
    return path.split(Platform.pathSeparator).last;
  }

  IconData _getFileIcon(String path) {
    final lowerPath = path.toLowerCase();

    if (lowerPath.endsWith('.pdf')) {
      return Icons.picture_as_pdf;
    }

    if (lowerPath.endsWith('.jpg') ||
        lowerPath.endsWith('.jpeg') ||
        lowerPath.endsWith('.png')) {
      return Icons.image;
    }

    return Icons.insert_drive_file;
  }

  Future<void> _deleteDocument(
    BuildContext context,
  ) async {
    final provider = context.read<DocumentProvider>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Document'),
          content: const Text(
            'Are you sure you want to delete this document?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    await provider.deleteDocument(
      documentIndex,
    );

    if (!context.mounted) {
      return;
    }

    Navigator.pop(
      context,
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileName = _getFileName(
      document.filePath,
    );

    final fileIcon = _getFileIcon(
      document.filePath,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Details'),
        actions: [
          IconButton(
            tooltip: 'Favorite',
            icon: Icon(
              document.isFavorite
                  ? Icons.star
                  : Icons.star_border,
              color: document.isFavorite
                  ? Colors.amber
                  : null,
            ),
            onPressed: () async {
              await context
                  .read<DocumentProvider>()
                  .toggleFavorite(
                    documentIndex,
                  );

              if (!context.mounted) {
                return;
              }

              Navigator.pop(
                context,
                true,
              );
            },
          ),
          IconButton(
            tooltip: 'Pin',
            icon: Icon(
              document.isPinned
                  ? Icons.push_pin
                  : Icons.push_pin_outlined,
              color: document.isPinned
                  ? Colors.orange
                  : null,
            ),
            onPressed: () async {
              await context
                  .read<DocumentProvider>()
                  .togglePinned(
                    documentIndex,
                  );

              if (!context.mounted) {
                return;
              }

              Navigator.pop(
                context,
                true,
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              width: 95,
              height: 95,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer,
                borderRadius:
                    BorderRadius.circular(24),
              ),
              child: Icon(
                fileIcon,
                size: 52,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),
          ),

          const SizedBox(height: 20),

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

          const SizedBox(height: 10),

          Center(
            child: Chip(
              avatar: const Icon(
                Icons.category,
                size: 18,
              ),
              label: Text(
                document.category,
              ),
            ),
          ),

          if (document.isFavorite ||
              document.isPinned) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                if (document.isFavorite)
                  const Chip(
                    avatar: Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    label: Text('Favorite'),
                  ),
                if (document.isFavorite &&
                    document.isPinned)
                  const SizedBox(width: 8),
                if (document.isPinned)
                  const Chip(
                    avatar: Icon(
                      Icons.push_pin,
                      color: Colors.orange,
                    ),
                    label: Text('Pinned'),
                  ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding:
                  const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Document Information',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight:
                              FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 18),

                  _InfoRow(
                    icon: Icons.category,
                    label: 'Category',
                    value: document.category,
                  ),

                  const Divider(height: 24),

                  _InfoRow(
                    icon: Icons.calendar_today,
                    label: 'Date Added',
                    value: _formatDate(
                      document.createdAt,
                    ),
                  ),

                  const Divider(height: 24),

                  _InfoRow(
                    icon: fileIcon,
                    label: 'File',
                    value: fileName,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding:
                  const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notes',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight:
                              FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    document.notes.trim().isEmpty
                        ? 'No notes added.'
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

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DocumentPreviewPage(
                      title: document.title,
                      filePath: document.filePath,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.open_in_new,
              ),
              label: const Text(
                'Open Document',
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddDocumentPage(
                      document: document,
                      documentIndex:
                          documentIndex,
                    ),
                  ),
                );

                if (!context.mounted) {
                  return;
                }

                Navigator.pop(
                  context,
                  true,
                );
              },
              icon: const Icon(
                Icons.edit,
              ),
              label: const Text(
                'Edit Document',
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                _deleteDocument(context);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              label: const Text(
                'Delete Document',
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
  Widget build(
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 22,
          color: Theme.of(context)
              .colorScheme
              .primary,
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
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
                      fontWeight:
                          FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}