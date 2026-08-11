import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_document_page.dart';
import 'document_preview_page.dart';
import 'providers/document_provider.dart';
import 'widgets/empty_documents.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = "All";

  final List<String> _categories = [
    "All",
    "Aadhaar",
    "PAN",
    "Passport",
    "Driving Licence",
    "Voter ID",
    "Medical",
    "Education",
    "Finance",
    "Other",
  ];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DocumentProvider>(context);

    final searchText = _searchController.text.trim().toLowerCase();

    final filteredDocuments = provider.documents.where((document) {
      final matchesSearch =
          document.title.toLowerCase().contains(searchText) ||
          document.category.toLowerCase().contains(searchText) ||
          document.notes.toLowerCase().contains(searchText);

      final matchesCategory = _selectedCategory == "All" ||
          document.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Documents"),
      ),
      body: provider.documents.isEmpty
          ? const EmptyDocuments()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    12,
                    12,
                    12,
                    8,
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search documents...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),

                SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final selected =
                          category == _selectedCategory;

                      return Padding(
                        padding: const EdgeInsets.only(
                          right: 8,
                        ),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: selected,
                          onSelected: (_) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: filteredDocuments.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 60,
                              ),
                              SizedBox(height: 12),
                              Text(
                                "No documents found",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Try another search or category.",
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(
                            bottom: 80,
                          ),
                          itemCount: filteredDocuments.length,
                          itemBuilder: (context, index) {
                            final doc =
                                filteredDocuments[index];

                            final originalIndex =
                                provider.documents.indexOf(doc);

                            return Card(
                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DocumentPreviewPage(
                                        title: doc.title,
                                        filePath: doc.filePath,
                                      ),
                                    ),
                                  );
                                },
                                leading: const Icon(
                                  Icons.description,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  doc.title,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  doc.category,
                                ),
                                trailing: Row(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      tooltip: "Edit",
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                AddDocumentPage(
                                              document: doc,
                                              documentIndex:
                                                  originalIndex,
                                            ),
                                          ),
                                        );

                                        if (context.mounted) {
                                          await provider
                                              .loadDocuments();
                                        }
                                      },
                                    ),
                                    IconButton(
                                      tooltip: "Delete",
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        final confirm =
                                            await showDialog<
                                                bool>(
                                          context: context,
                                          builder: (_) =>
                                              AlertDialog(
                                            title: const Text(
                                              "Delete Document",
                                            ),
                                            content: const Text(
                                              "Are you sure you want to delete this document?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(
                                                  context,
                                                  false,
                                                ),
                                                child:
                                                    const Text(
                                                  "Cancel",
                                                ),
                                              ),
                                              FilledButton(
                                                onPressed: () =>
                                                    Navigator.pop(
                                                  context,
                                                  true,
                                                ),
                                                child:
                                                    const Text(
                                                  "Delete",
                                                ),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          await provider
                                              .deleteDocument(
                                            originalIndex,
                                          );

                                          if (context.mounted) {
                                            ScaffoldMessenger
                                                .of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Document deleted successfully.",
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Document",
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddDocumentPage(),
            ),
          );

          if (context.mounted) {
            await provider.loadDocuments();
          }
        },
      ),
    );
  }
}