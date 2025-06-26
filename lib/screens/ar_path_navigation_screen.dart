import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:flutter/material.dart';
import 'package:museum_ar_guide/services/classifier_service.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;
import 'package:museum_ar_guide/screens/profile_screen.dart';
import 'package:museum_ar_guide/screens/museum_select_screen.dart';

class ARPathNavigationScreen extends StatefulWidget {
  const ARPathNavigationScreen({super.key});
  @override
  State<ARPathNavigationScreen> createState() => _ARPathNavigationScreenState();
}

class _ARPathNavigationScreenState extends State<ARPathNavigationScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  final List<ARNode> nodes = [];
  List<Map<String, dynamic>> artworks = [];
  List<ImageProvider?> preloadedImages = [];
  bool isLoading = true;
  int? tappedIndex;

  // Demo: Sabit güzergah noktaları (göz boyama için sabit bırak!)
  final List<vmath.Vector3> pathPoints = [
    vmath.Vector3(0.0, -0.4, -0.7),
    vmath.Vector3(0.0, -0.4, -1.5),
    vmath.Vector3(0.35, -0.4, -2.1),
  ];

  @override
  void initState() {
    super.initState();
    _fetchAndPreload();
  }

  Future<void> _fetchAndPreload() async {
    // Firestore’dan veriler gelir, imgUrl'ler preload edilir
    final results = await ClassifierService().getSampleArtworks(limit: 3);
    List<ImageProvider?> imgs = [];
    for (final artwork in results) {
      final url = artwork['imgUrl'] as String?;
      if (url != null) {
        try {
          final imageProvider = NetworkImage(url);
          // precacheImage arka planda yükler, hata olursa null ata
          await precacheImage(imageProvider, context);
          imgs.add(imageProvider);
        } catch (_) {
          imgs.add(null);
        }
      } else {
        imgs.add(null);
      }
    }
    setState(() {
      artworks = results;
      preloadedImages = imgs;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("AR Güzergah"),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            tooltip: "Profilim",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!isLoading) ARView(onARViewCreated: onARViewCreated),
          if (isLoading) const Center(child: CircularProgressIndicator()),
          if (!isLoading) ...[
            Positioned(
              top: 18,
              left: 12,
              right: 12,
              child: Card(
                color: Colors.white.withOpacity(0.95),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    "Güzergahı takip et, kutuya tıkla: Eser bilgisini ekranda gör!",
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            // Bilgi paneli
            if (tappedIndex != null && tappedIndex! < artworks.length)
              _buildInfoDialog(
                context,
                artworks[tappedIndex!],
                preloadedImages[tappedIndex!],
              ),
            // En altta müze seçimine dön butonu
            Positioned(
              left: 24,
              right: 24,
              bottom: 30,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.home_outlined),
                label: const Text("Müze Seçimine Dön"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.indigo,
                  side: const BorderSide(color: Colors.indigo, width: 1.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(100, 44),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const MuseumSelectScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoDialog(
    BuildContext context,
    Map<String, dynamic> artwork,
    ImageProvider? img,
  ) {
    return Positioned(
      left: 8,
      right: 8,
      bottom: 110,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.98),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16)],
          ),
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (img != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image(
                    image: img,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  height: 170,
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.image, size: 60)),
                ),
              const SizedBox(height: 14),
              Text(
                artwork['title'] ?? "",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  setState(() => tappedIndex = null);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.indigo,
                  minimumSize: const Size(70, 40),
                ),
                child: const Text("Kapat"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) async {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: false,
      showWorldOrigin: false,
      showAnimatedGuide: false,
    );
    arObjectManager.onInitialize();

    // AR kutular eklenmeden Firestore ve img preload bitmesi beklenir:
    while (isLoading) await Future.delayed(const Duration(milliseconds: 50));
    await addArtworksNodes();
    arObjectManager.onNodeTap = onNodeTap;
  }

  // AR'da kutulara isim ekle
  Future<void> addArtworksNodes() async {
    // Define the recognized label you want to compare with
    const String recognizedLabel = "your_label_here"; // TODO: Set this to the correct label

    for (int i = 0; i < artworks.length; i++) {
      final isRecognized = (artworks[i]['label'] == recognizedLabel);
      final uri =
          isRecognized
              ? "assets/models/Box_green.glb" // Yeşil kutu modelin olursa!
              : "https://github.com/KhronosGroup/glTF-Sample-Models/raw/main/2.0/Box/glTF-Binary/Box.glb";

      final node = ARNode(
        name: 'artwork_$i',
        type: NodeType.webGLB,
        uri: uri,
        scale: vmath.Vector3(0.1, 0.1, 0.1),
        position: pathPoints[i],
        rotation: vmath.Vector4(0, 1, 0, 0),
        text: '',
      );
      await arObjectManager?.addNode(node);
      nodes.add(node);
    }
  }


  void onNodeTap(List<String> nodeNames) {
    final tapped = nodeNames.firstWhere(
      (n) => n.startsWith("artwork_"),
      orElse: () => "",
    );
    if (tapped.isEmpty) return;
    final index = int.tryParse(tapped.split("_").last);
    if (index == null || index >= artworks.length) return;
    setState(() {
      tappedIndex = index;
    });
  }
}
