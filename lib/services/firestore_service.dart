import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getArtworkInfo(String label) async {
    try {
      final doc = await _db.collection('artworks').doc(label).get();
      if (doc.exists) {
        return doc.data();
      } else {
        return null;
      }
    } catch (e) {
      print("Firestore hata: $e");
      return null;
    }
  }
}
