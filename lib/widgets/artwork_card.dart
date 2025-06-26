import 'package:flutter/material.dart';

class ArtworkCard extends StatelessWidget {
  final String title;
  final String? imgUrl;
  final VoidCallback? onTap;

  const ArtworkCard({super.key, required this.title, this.imgUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: ListTile(
        leading:
            imgUrl != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imgUrl!,
                    width: 54,
                    height: 54,
                    fit: BoxFit.cover,
                  ),
                )
                : const Icon(Icons.image_outlined, size: 48),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        onTap: onTap,
      ),
    );
  }
}
