import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? user?.email?.split('@')[0] ?? "";
    final email = user?.email ?? "";
    final photoURL = user?.photoURL;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profilim"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Çıkış Yap",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false);
              // Snackbar ile geri bildirim
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Çıkış yapıldı!')));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PROFİL BAR
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              color: Colors.indigo.shade50,
              child: ListTile(
                leading:
                    photoURL != null
                        ? CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(photoURL),
                        )
                        : const CircleAvatar(
                          radius: 28,
                          child: Icon(Icons.person, size: 30),
                        ),
                title: Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(email),
              ),
            ),
            const SizedBox(height: 22),

            // FAVORİLERİM BAŞLIĞI
            const Text(
              "Favorilerim",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 7),

            // FAVORİLERİM LİSTESİ
            SizedBox(
              height: 110,
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(user!.uid)
                        .collection("favorites")
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final favs = snapshot.data!.docs;
                  if (favs.isEmpty) {
                    return const Center(
                      child: Text(
                        "Henüz favori eserin yok.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: favs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, i) {
                      final data = favs[i].data() as Map<String, dynamic>;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                        child: Container(
                          width: 92,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (data['imgUrl'] != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    data['imgUrl'],
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              else
                                const Icon(
                                  Icons.star,
                                  size: 38,
                                  color: Colors.amber,
                                ),
                              const SizedBox(height: 6),
                              Text(
                                data['title'] ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 26),

            // GEZİLEN ESERLER BAŞLIĞI
            const Text(
              "Gezdiğiniz Eserler",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // GEZİLENLER (DİKEY)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(user.uid)
                        .collection("visitedArtworks")
                        .orderBy("visitedAt", descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "Henüz hiç eser tanımadınız.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, i) {
                      final data = docs[i].data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        color: Colors.white,
                        elevation: 2,
                        child: ListTile(
                          leading:
                              data['imgUrl'] != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      data['imgUrl'],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : const Icon(Icons.image_outlined, size: 44),
                          title: Text(data['title'] ?? data['label']),
                          subtitle:
                              data['visitedAt'] != null
                                  ? Text(
                                    _formatTimestamp(data['visitedAt']),
                                    style: const TextStyle(fontSize: 13),
                                  )
                                  : null,
                          onTap: () {
                            // Buraya ileride detay ekranına geçiş yapılabilir
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

  // Tarihi daha okunabilir göster
  String _formatTimestamp(dynamic ts) {
    if (ts is Timestamp) {
      final date = ts.toDate();
      return "${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    }
    return "";
  }
}
