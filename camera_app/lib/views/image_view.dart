import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String path;
  const ImageWidget({required this.path, super.key});

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Image.network(
            path,
            fit: BoxFit.cover,
          )
        : Image.file(
            File(path),
            fit: BoxFit.cover,
          );
  }
}
