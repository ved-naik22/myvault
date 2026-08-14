import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/document_model.dart';
import 'providers/document_provider.dart';

class AddDocumentPage extends StatefulWidget {
  final DocumentModel? document;
  final int? documentIndex;

  const AddDocumentPage({
    super.key,
    this.document,
    this.documentIndex,
  });

  bool get isEditing => document != null && documentIndex != null;

  @override
  State<AddDocumentPage> createState() => _AddDocumentPageState();
}

class _AddDocumentPageState extends State<AddDocumentPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _notesController;

  String _selectedCategory = "Aadhaar";
  String? _selectedFilePath;

  final List<String> _categories = [
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

    _titleController = TextEditingController(
      text: widget.document?.title ?? "",
    );

    _notesController = TextEditingController(
      text: widget.document?.notes ?? "",
    );

    if (widget.document != null) {
      _selectedCategory = widget.document!.category;
      _selectedFilePath = widget.document!.filePath;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'jpg',
        'jpeg',
        'png',
      ],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFilePath = result.files.single.path!;
      });
    }
  }

  Future<void> _saveDocument() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a document."),
        ),
      );
      return;
    }

    final provider = context.read<DocumentProvider>();

    if (widget.isEditing) {
      final oldDocument = widget.document!;

      final updatedDocument = DocumentModel(
        title: _titleController.text.trim(),
        category: _selectedCategory,
        notes: _notesController.text.trim(),
        filePath: _selectedFilePath!,
        createdAt: oldDocument.createdAt,
      );

      await provider.updateDocument(
        widget.documentIndex!,
        updatedDocument,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Document updated successfully!"),
        ),
      );
    } else {
      final document = DocumentModel(
        title: _titleController.text.trim(),
        category: _selectedCategory,
        notes: _notesController.text.trim(),
        filePath: _selectedFilePath!,
        createdAt: DateTime.now(),
      );

      await provider.addDocument(document);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Document saved successfully!"),
        ),
      );
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.isEditing;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Document" : "Add Document",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Document Title",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a document title";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Notes",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.notes),
                ),
              ),

              const SizedBox(height: 25),

              OutlinedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: const Text("Choose Image or PDF"),
              ),

              const SizedBox(height: 12),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.insert_drive_file,
                  ),
                  title: Text(
                    _selectedFilePath ?? "No file selected",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saveDocument,
                  icon: Icon(
                    isEditing ? Icons.update : Icons.save,
                  ),
                  label: Text(
                    isEditing
                        ? "Update Document"
                        : "Save Document",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}