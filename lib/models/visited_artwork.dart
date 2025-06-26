import 'package:cloud_firestore/cloud_firestore.dart';

class VisitedArtwork {
  final String artworkId;
  final String title;
  final String imgUrl;
  final DateTime visitedAt;

  VisitedArtwork({
    required this.artworkId,
    required this.title,
    required this.imgUrl,
    required this.visitedAt,
  });

  factory VisitedArtwork.fromMap(Map<String, dynamic> map) {
    return VisitedArtwork(
      artworkId: map['artworkId'] ?? '',
      title: map['title'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      visitedAt: (map['visitedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    "artworkId": artworkId,
    "title": title,
    "imgUrl": imgUrl,
    "visitedAt": visitedAt,
  };
}
