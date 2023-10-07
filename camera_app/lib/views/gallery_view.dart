import 'package:camera/camera.dart';
import 'package:camera_app/views/image_view.dart';
import 'package:flutter/material.dart';

class GalleryWidget extends StatefulWidget {
  final List<XFile?> pictures;
  const GalleryWidget({super.key, required this.pictures});

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, childAspectRatio: 2.0),
      itemCount: widget.pictures.length,
      itemBuilder: (BuildContext context, int index) => Card(
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => Dialog(
                child: ImageWidget(
                  path: widget.pictures[index]!.path,
                ),
              ),
            );
          },
          child: GridTile(
            child: ImageWidget(
              path: widget.pictures[index]!.path,
            ),
          ),
        ),
      ),
    );
  }
}
