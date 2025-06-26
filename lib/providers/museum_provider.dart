import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MuseumProvider extends ChangeNotifier {
  bool isLoading = true;
  List<Map<String, dynamic>> museums = [];
  String? error;

  MuseumProvider() {
    fetchMuseums();
  }

  Future<void> fetchMuseums() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('museums').get();
      museums =
          snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
    } catch (e) {
      error = e.toString();
      museums = [];
    }
    isLoading = false;
    notifyListeners();
  }
}
