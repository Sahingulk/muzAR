import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/visited_artwork.dart';

class VisitedArtworkProvider extends ChangeNotifier {
  final List<VisitedArtwork> _visited = [];
  bool _isLoading = false;

  List<VisitedArtwork> get visited => _visited;
  bool get isLoading => _isLoading;

  Future<void> fetchVisitedArtworks(String userId) async {
    _isLoading = true;
    notifyListeners();

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('visitedArtworks')
        .orderBy('visitedAt', descending: true);

    final snapshot = await ref.get();
    _visited.clear();
    for (final doc in snapshot.docs) {
      _visited.add(VisitedArtwork.fromMap(doc.data()));
    }
    _isLoading = false;
    notifyListeners();
  }
}
