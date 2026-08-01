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

  @override
  State<AddDocumentPage> createState() => _AddDocumentPageState();
}

class _AddDocumentPageState extends State<AddDocumentPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

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

  if (widget.document != null) {
    _titleController.text = widget.document!.title;
    _notesController.text = widget.document!.notes;
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
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
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

  final document = DocumentModel(
    title: _titleController.text.trim(),
    category: _selectedCategory,
    notes: _notesController.text.trim(),
    filePath: _selectedFilePath!,
    createdAt: widget.document?.createdAt ?? DateTime.now(),
  );

  final provider = context.read<DocumentProvider>();

  if (widget.document == null) {
    await provider.addDocument(document);
  } else {
    await provider.updateDocument(
      widget.documentIndex!,
      document,
    );
  }

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        widget.document == null
            ? "Document saved successfully!"
            : "Document updated successfully!",
      ),
    ),
  );

  Navigator.pop(context);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text(
  widget.document == null
      ? "Add Document"
      : "Edit Document",
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
                items: _categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
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
                  leading: const Icon(Icons.insert_drive_file),
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
                  icon: const Icon(Icons.save),
                  label: Text(
                    widget.document == null
                        ? "Save Document"
                        : "Update Document",
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