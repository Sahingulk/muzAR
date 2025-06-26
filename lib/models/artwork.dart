class Artwork {
  final String id;
  final String title;
  final String imgUrl;
  final String? description;
  final String? longDescription;
  final String? museumId; // Hangi müzeye ait
  final double? posX, posY, posZ; // (Opsiyonel) Navigasyon için AR konumu

  Artwork({
    required this.id,
    required this.title,
    required this.imgUrl,
    this.description,
    this.longDescription,
    this.museumId,
    this.posX,
    this.posY,
    this.posZ,
  });

  factory Artwork.fromMap(Map<String, dynamic> map, String docId) {
    return Artwork(
      id: docId,
      title: map['title'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      description: map['description'],
      longDescription: map['longDescription'],
      museumId: map['museumId'],
      posX: (map['posX'] as num?)?.toDouble(),
      posY: (map['posY'] as num?)?.toDouble(),
      posZ: (map['posZ'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    "title": title,
    "imgUrl": imgUrl,
    "description": description,
    "longDescription": longDescription,
    "museumId": museumId,
    "posX": posX,
    "posY": posY,
    "posZ": posZ,
  };
}
