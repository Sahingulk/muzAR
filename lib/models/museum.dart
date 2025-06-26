class Museum {
  final String id;
  final String name;
  final String city;
  final String imgUrl;
  final String? tfliteUrl; // Her müzenin özel modeli
  final String? description;

  Museum({
    required this.id,
    required this.name,
    required this.city,
    required this.imgUrl,
    this.tfliteUrl,
    this.description,
  });

  factory Museum.fromMap(Map<String, dynamic> map, String docId) {
    return Museum(
      id: docId,
      name: map['name'] ?? '',
      city: map['city'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      tfliteUrl: map['tfliteUrl'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() => {
    "name": name,
    "city": city,
    "imgUrl": imgUrl,
    "tfliteUrl": tfliteUrl,
    "description": description,
  };
}
