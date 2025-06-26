import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/artwork.dart';

class ArtworkProvider extends ChangeNotifier {
  final List<Artwork> _artworks = [];
  bool _isLoading = false;

  List<Artwork> get artworks => _artworks;
  bool get isLoading => _isLoading;

  Future<void> fetchArtworks({String? museumId}) async {
    _isLoading = true;
    notifyListeners();

    final query = FirebaseFirestore.instance.collection('artworks');
    final snapshot =
        museumId != null
            ? await query.where('museumId', isEqualTo: museumId).get()
            : await query.get();

    _artworks.clear();
    for (final doc in snapshot.docs) {
      _artworks.add(Artwork.fromMap(doc.data(), doc.id));
    }
    _isLoading = false;
    notifyListeners();
  }
}
