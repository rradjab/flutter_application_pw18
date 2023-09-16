import 'package:camera_app/views/camera_view.dart';
import 'package:camera_app/views/image_view.dart';
import 'package:flutter/material.dart';

class GalleryWidget extends StatefulWidget {
  const GalleryWidget({super.key});

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, childAspectRatio: 2.0),
      itemCount: pictures.length,
      itemBuilder: (BuildContext context, int index) => Card(
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => Dialog(
                child: ImageWidget(
                  path: pictures[index]!.path,
                ),
              ),
            );
          },
          child: GridTile(
            child: ImageWidget(
              path: pictures[index]!.path,
            ),
          ),
        ),
      ),
    );
  }
}
