import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
// Yukarıya ekle!

final ClassifierService classifier =
    ClassifierService(); // Sınıf değişkeni olarak ekle


class ClassifierService {
  Interpreter? _interpreter;
  List<String>? _labels;

  Future<void> loadModel() async {
    _interpreter ??= await Interpreter.fromAsset('assets/models/museum_model.tflite');
    _labels ??= await loadLabels();
  }

  Future<List<String>> loadLabels() async {
    final labelsData = await rootBundle.loadString('assets/models/labels.txt');
    // Boşluklu veya boş satırları at!
    return labelsData
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }


  Future<String> classify(File imageFile) async {
    await loadModel();
    final labels = _labels!;

    img.Image? image = img.decodeImage(await imageFile.readAsBytes());
    var inputImage = img.copyResize(image!, width: 224, height: 224);

    List<List<List<double>>> imageMatrix = List.generate(
      224,
      (_) => List.generate(224, (_) => List.filled(3, 0.0)),
    );

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        dynamic pixelObj = inputImage.getPixel(x, y);

        int pixelValue = 0;
        try {
          if (pixelObj is int) {
            pixelValue = pixelObj;
          } else if (pixelObj.runtimeType.toString().toLowerCase().contains(
            "pixeluint8",
          )) {
            // PixelUint8 objesini map/dynamic olarak ele al, RGBA değerlerini elle topla!
            int r = pixelObj.r ?? pixelObj['r'] ?? 0;
            int g = pixelObj.g ?? pixelObj['g'] ?? 0;
            int b = pixelObj.b ?? pixelObj['b'] ?? 0;
            // int a = pixelObj.a ?? pixelObj['a'] ?? 0; // Gerekirse alabilirsin

            // int renk kodu oluştur (ARGB veya RGB formatına göre)
            pixelValue = (0xFF << 24) | (r << 16) | (g << 8) | b;
          } else {
            print("Bilinmeyen pixel tipi: ${pixelObj.runtimeType}");
            pixelValue = 0;
          }
        } catch (e, s) {
          print("Pixel value alma hatası: $e\n$s");
          pixelValue = 0;
        }

        double r = ((pixelValue >> 16) & 0xFF) / 255.0;
        double g = ((pixelValue >> 8) & 0xFF) / 255.0;
        double b = (pixelValue & 0xFF) / 255.0;
        imageMatrix[y][x] = [r, g, b];
      }
    }



    var input = [imageMatrix];

   var output = List.filled(
      1 * labels.length,
      0.0,
    ).reshape([1, labels.length]);
    _interpreter!.run(input, output);

    // ↓ Bu şekilde devam et:
   final outputList =
        output[0].map((e) => e is double ? e : (e as num).toDouble()).toList();
    final maxValue = outputList.reduce((a, b) => a > b ? a : b);
    final idx = outputList.indexOf(maxValue);
    return labels[idx];


  }

   /// Sadece örnek için: limit kadar eser çek
  Future<List<Map<String, dynamic>>> getSampleArtworks({int limit = 3}) async {
    final query =
        await FirebaseFirestore.instance
            .collection(
              "artworks",
            ) // Koleksiyon adını kendi koleksiyonuna göre düzenle!
            .limit(limit)
            .get();

    // Map<String, dynamic> listesi olarak döndür
    return query.docs.map((doc) => doc.data()).toList();
  }
}
