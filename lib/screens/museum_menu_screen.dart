import 'package:flutter/material.dart';
import 'package:museum_ar_guide/screens/profile_screen.dart';
import 'object_detection_screen.dart';
import 'ar_path_navigation_screen.dart';

class MuseumMenuScreen extends StatelessWidget {
  final String museumId;
  final String tfliteUrl;
  final String? museumName;
  final String? museumImg;

  const MuseumMenuScreen({
    super.key,
    required this.museumId,
    required this.tfliteUrl,
    this.museumName,
    this.museumImg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(museumName ?? "Müze"), centerTitle: true,
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
      ),
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (museumImg != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  museumImg!,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text("Eser Tanı"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                textStyle: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ObjectDetectionScreen(
                          museumId: museumId,
                          tfliteUrl: tfliteUrl,
                        ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              icon: const Icon(Icons.alt_route),
              label: const Text("Güzergahı Göster"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                backgroundColor: Colors.indigo[100],
                foregroundColor: Colors.indigo[900],
                textStyle: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ARPathNavigationScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
