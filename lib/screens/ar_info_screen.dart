// ... [importlar aynı kalacak]
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/widgets/ar_view.dart';
import 'package:flutter/material.dart';
import 'package:museum_ar_guide/screens/profile_screen.dart';
import 'package:museum_ar_guide/screens/museum_select_screen.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../services/tts_service.dart';

class ARInfoScreen extends StatefulWidget {
  final String label;
  const ARInfoScreen({super.key, required this.label});

  @override
  State<ARInfoScreen> createState() => _ARInfoScreenState();
}

class _ARInfoScreenState extends State<ARInfoScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARNode? boxNode;
  bool showInfoPanel = false;
  Map<String, dynamic>? artworkInfo;
  bool isLoading = false;
  bool isFavorite = false;
  final TtsService ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _getArtworkInfo();
    _checkIfFavorite();
  }

  Future<void> _getArtworkInfo() async {
    setState(() => isLoading = true);
    try {
      artworkInfo = await FirestoreService().getArtworkInfo(widget.label);
    } catch (e) {
      artworkInfo = {"description": "Bilgi getirilemedi: $e"};
    }
    setState(() => isLoading = false);
  }

  Future<void> _checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final favDoc =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .collection("favorites")
            .doc(widget.label)
            .get();
    setState(() => isFavorite = favDoc.exists);
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || artworkInfo == null) return;
    final favorites = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites');
    if (isFavorite) {
      await favorites.doc(widget.label).delete();
      setState(() => isFavorite = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Favorilerden kaldırıldı")));
    } else {
      await favorites.doc(widget.label).set({
        'title': artworkInfo!['title'],
        'imgUrl': artworkInfo!['imgUrl'],
        'addedAt': FieldValue.serverTimestamp(),
      });
      setState(() => isFavorite = true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Favorilere eklendi!")));
    }
  }

  @override
  void dispose() {
    ttsService.stop(); // <-- TTS'yi durdur
    arSessionManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.label),
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
          ARView(onARViewCreated: onARViewCreated),
          Positioned(
            left: 0,
            right: 0,
            bottom: 110,
            child: Center(
              child: Card(
                color: Colors.black.withOpacity(0.75),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 10,
                  ),
                  child: const Text(
                    "Detaylı bilgi için bilgi küpüne basın!",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ),
          ),
          if (showInfoPanel)
            Positioned(
              left: 8,
              right: 8,
              bottom: 24,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.98),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 16),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                  child:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.75,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (artworkInfo?['imgUrl'] != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Image.network(
                                        artworkInfo!['imgUrl'],
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  const SizedBox(height: 18),
                                  Text(
                                    artworkInfo?['title'] ?? widget.label,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    artworkInfo?['longDescription'] ??
                                        artworkInfo?['description'] ??
                                        "Bilgi yok",
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed:
                                            (artworkInfo?['longDescription'] ??
                                                        artworkInfo?['description']) ==
                                                    null
                                                ? null
                                                : () => ttsService.speak(
                                                  artworkInfo?['longDescription'] ??
                                                      artworkInfo?['description'],
                                                ),
                                        icon: const Icon(Icons.volume_up),
                                        label: const Text("Tekrar Dinle"),
                                      ),
                                      OutlinedButton.icon(
                                        icon: Icon(
                                          isFavorite
                                              ? Icons.star
                                              : Icons.star_border,
                                          color:
                                              isFavorite
                                                  ? Colors.amber
                                                  : Colors.indigo,
                                        ),
                                        label: Text(
                                          isFavorite
                                              ? "Favorilerde"
                                              : "Favori Ekle",
                                        ),
                                        onPressed: _toggleFavorite,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close, size: 26),
                                        onPressed:
                                            () => setState(
                                              () => showInfoPanel = false,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  OutlinedButton.icon(
                                    icon: const Icon(Icons.home_outlined),
                                    label: const Text("Müze Seçimine Dön"),
                                    onPressed: () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder:
                                              (_) => const MuseumSelectScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: false,
      showWorldOrigin: false,
      showAnimatedGuide: false,
    );
    arObjectManager.onInitialize();

    addBoxObject();

    arObjectManager.onNodeTap = (List<String> nodes) {
      if (nodes.contains('infoBox')) {
        setState(() => showInfoPanel = true);
      }
    };
  }

  Future<void> addBoxObject() async {
    if (boxNode != null) {
      await arObjectManager?.removeNode(boxNode!);
    }
    final node = ARNode(
      name: 'infoBox',
      type: NodeType.webGLB,
      uri:
          "https://github.com/KhronosGroup/glTF-Sample-Models/raw/main/2.0/Box/glTF-Binary/Box.glb",
      scale: vmath.Vector3(0.08, 0.08, 0.08),
      position: vmath.Vector3(0.0, -0.3, -0.7),
      rotation: vmath.Vector4(0, 1, 0, 0),
      text: '',
    );
    await arObjectManager?.addNode(node);
    boxNode = node;
  }
}
