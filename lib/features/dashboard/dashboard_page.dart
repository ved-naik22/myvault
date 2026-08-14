import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../documents/add_document_page.dart';
import '../documents/documents_page.dart';
import '../documents/providers/document_provider.dart';
import '../profile/profile_page.dart';
import '../profile/providers/profile_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final documentProvider = context.watch<DocumentProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    final documents = documentProvider.documents;
    final profile = profileProvider.profile;

    final Map<String, int> categoryCounts = {};

    for (final document in documents) {
      categoryCounts[document.category] =
          (categoryCounts[document.category] ?? 0) + 1;
    }

    final recentDocuments = [...documents];

    recentDocuments.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );

    if (recentDocuments.length > 5) {
      recentDocuments.removeRange(
        5,
        recentDocuments.length,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("MyVault"),
        actions: [
          IconButton(
            tooltip: "Profile",
            icon: const Icon(Icons.person),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfilePage(),
                ),
              );

              if (context.mounted) {
                await profileProvider.loadProfile();
              }
            },
          ),

          IconButton(
            tooltip: "Documents",
            icon: const Icon(Icons.folder),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DocumentsPage(),
                ),
              );

              if (context.mounted) {
                await documentProvider.loadDocuments();
              }
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await documentProvider.loadDocuments();
          await profileProvider.loadProfile();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile header
            Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfilePage(),
                    ),
                  );

                  if (context.mounted) {
                    await profileProvider.loadProfile();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        child: Icon(
                          Icons.person,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.fullName.isNotEmpty == true
                                  ? "Hello, ${profile!.fullName}"
                                  : "Welcome to MyVault",
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile != null
                                  ? "View your profile"
                                  : "Create your profile",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Your Vault",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Keep your important documents organized.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            // Statistics
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: "Documents",
                    value: documents.length.toString(),
                    icon: Icons.description,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: "Categories",
                    value: categoryCounts.length.toString(),
                    icon: Icons.category,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Quick Actions
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    title: "Add Document",
                    icon: Icons.add_circle,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AddDocumentPage(),
                        ),
                      );

                      if (context.mounted) {
                        await documentProvider
                            .loadDocuments();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionCard(
                    title: "Documents",
                    icon: Icons.folder_open,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const DocumentsPage(),
                        ),
                      );

                      if (context.mounted) {
                        await documentProvider
                            .loadDocuments();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionCard(
                    title: "Profile",
                    icon: Icons.person,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfilePage(),
                        ),
                      );

                      if (context.mounted) {
                        await profileProvider
                            .loadProfile();
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Categories
            if (categoryCounts.isNotEmpty) ...[
              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              ...categoryCounts.entries.map(
                (entry) {
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.folder),
                      ),
                      title: Text(entry.key),
                      trailing: Text(
                        entry.value.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],

            // Recent Documents
            const Text(
              "Recently Added",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (recentDocuments.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.folder_open,
                        size: 50,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "No documents yet",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Add your first document to MyVault.",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...recentDocuments.map(
                (document) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.description,
                      ),
                      title: Text(
                        document.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        document.category,
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const DocumentsPage(),
                          ),
                        );

                        if (context.mounted) {
                          await documentProvider
                              .loadDocuments();
                        }
                      },
                    ),
                  );
                },
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // Bottom-right quick add button
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Document",
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddDocumentPage(),
            ),
          );

          if (context.mounted) {
            await documentProvider.loadDocuments();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 8,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}