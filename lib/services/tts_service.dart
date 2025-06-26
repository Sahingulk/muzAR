import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> speak(String text) async {
    await _flutterTts.setLanguage("tr-TR");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.45); // konuşma hızı ayarı
    await _flutterTts.speak(text);
  }
  Future<void> stop() async {
    await _flutterTts.stop();
  }

}
