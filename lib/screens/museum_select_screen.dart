

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:museum_ar_guide/screens/profile_screen.dart';
import 'museum_menu_screen.dart';

class MuseumSelectScreen extends StatelessWidget {
  const MuseumSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Müze Seç"),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            tooltip: "Profilim",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.account_balance, color: theme.primaryColor, size: 60),
            const SizedBox(height: 14),
            Text(
              "Ziyaret etmek istediğin müzeyi seç:",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('museums')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final museums = snapshot.data!.docs;
                  if (museums.isEmpty) {
                    return const Center(
                      child: Text(
                        "Henüz ekli müze yok.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: museums.length,
                    itemBuilder: (context, i) {
                      final museum = museums[i].data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 6,
                        ),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ListTile(
                          leading:
                              museum['imgUrl'] != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(9),
                                    child: Image.network(
                                      museum['imgUrl'],
                                      width: 54,
                                      height: 54,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : CircleAvatar(
                                    backgroundColor: theme.primaryColor
                                        .withOpacity(0.1),
                                    child: Icon(
                                      Icons.museum,
                                      color: theme.primaryColor,
                                      size: 32,
                                    ),
                                  ),
                          title: Text(
                            museum['name'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle:
                              museum['city'] != null
                                  ? Text(
                                    museum['city'],
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  )
                                  : null,
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => MuseumMenuScreen(
                                      museumId: museums[i].id,
                                      tfliteUrl: museum['tfliteUrl'],
                                      museumName: museum['name'],
                                      museumImg: museum['imgUrl'],
                                    ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
