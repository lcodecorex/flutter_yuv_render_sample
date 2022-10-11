import 'dart:ui' as ui;

import 'package:example/widgets/yuvdraw_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final imageData = await rootBundle.load('assets/dash.jpeg');
  final image = await decodeImageFromList(imageData.buffer.asUint8List());

  runApp(MaterialApp(home: ExampleApp(image: image)));
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key, required this.image}) : super(key: key);

  final ui.Image image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Origin RGBA Image:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: Center(child: RawImage(image: image))),
            ],
          ),
        ),
        const Text(
          'YUV420P Image:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        const Expanded(child: YUVDrawWidget()),
      ],
    );
  }
}
