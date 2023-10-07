import 'dart:async';
import 'package:camera_app/views/image_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget>
    with WidgetsBindingObserver {
  List<XFile?> pictures = [];
  late List<CameraDescription> cameras;
  CameraController? controller;

  Future<void> initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    await controller!.initialize();
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    if (controller == null || !cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
    super.didChangeAppLifecycleState(state);
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller?.dispose();
    }

    final CameraController cameraController = CameraController(
        cameraDescription,
        kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg);

    controller = cameraController;
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    unawaited(initCamera());
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (controller != null)
            ? Center(child: CameraPreview(controller!))
            : const SizedBox(),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FloatingActionButton(
              onPressed: () async {
                pictures.add(await controller!.takePicture());
                setState(() {});
              },
              child: const Icon(Icons.camera),
            ),
          ),
        ),
        if (pictures.isNotEmpty)
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: ImageWidget(
                        path: pictures[pictures.length - 1]!.path,
                      ),
                    ),
                  );
                },
                child: ImageWidget(
                  path: pictures[pictures.length - 1]!.path,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
