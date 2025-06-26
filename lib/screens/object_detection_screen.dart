
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import '../services/classifier_service.dart';
import 'ar_info_screen.dart';

class ObjectDetectionScreen extends StatefulWidget {
  final String museumId;
  final String tfliteUrl;
  const ObjectDetectionScreen({
    super.key,
    required this.museumId,
    required this.tfliteUrl,
  });

  @override
  State<ObjectDetectionScreen> createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  CameraController? _controller;
  bool _isReady = false;
  String? _label;
  bool _isDetecting = false;

  final ClassifierService classifier = ClassifierService();

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    await Permission.camera.request();
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller!.initialize();
    setState(() => _isReady = true);
  }

  Future<void> _takePictureAndDetect() async {
    if (!_isReady || _isDetecting) return;
    setState(() {
      _isDetecting = true;
      _label = null;
    });
    try {
      final image = await _controller!.takePicture();
      final directory = await getTemporaryDirectory();
      final tempPath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = await File(image.path).copy(tempPath);
      final label = await classifier.classify(tempFile);
      setState(() {
        _label = label;
        _isDetecting = false;
      });
    } catch (e) {
      setState(() {
        _label = 'Hata: $e';
        _isDetecting = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_isReady) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Eser Tanıma"),
        backgroundColor: theme.primaryColor,
        elevation: 2,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.camera_alt_rounded,
                    size: 56,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Kamerayı esere doğrultup tara",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CameraPreview(_controller!),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _takePictureAndDetect,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: _isDetecting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search),
                    label: Text(_isDetecting ? "Taranıyor..." : "Eseri Tara"),
                  ),
                  const SizedBox(height: 18),
                  if (_label != null && !_label!.startsWith("Hata"))
                    Card(
                      color: Colors.green[50],
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          children: [
                            Text(
                              "Tespit edilen eser: ${_label!}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.view_in_ar),
                              label: const Text("AR ile Göster"),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ARInfoScreen(label: _label!),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_label != null && _label!.startsWith("Hata"))
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _label!,
                        style: const TextStyle(color: Colors.red, fontSize: 15),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
