import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;

class ARScreen extends StatefulWidget {
  const ARScreen({super.key});

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AR Demo")),
      body: ARView(onARViewCreated: onARViewCreated),
      floatingActionButton: FloatingActionButton(
        onPressed: addBoxObject,
        tooltip: "Küp ekle",
        child: const Icon(Icons.cable),
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
      showPlanes: true,
      customPlaneTexturePath: "images/triangle.png",
      showWorldOrigin: true,
    );
    arObjectManager.onInitialize();
  }

  Future<void> addBoxObject() async {
   final node = ARNode(
      name: 'infoBox',
      type: NodeType.webGLB,
      uri:
          "https://github.com/KhronosGroup/glTF-Sample-Models/raw/main/2.0/Fox/glTF-Binary/Fox.glb",
      scale: vmath.Vector3(0.08, 0.08, 0.08),
      position: vmath.Vector3(0.0, -0.3, -0.7),
      rotation: vmath.Vector4(0, 1, 0, 0),
      text: '',
    );
    await arObjectManager?.addNode(node);

  }
}
