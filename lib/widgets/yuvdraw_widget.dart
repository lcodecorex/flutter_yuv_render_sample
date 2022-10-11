import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'yuvdraw.dart';

class YUVDrawWidget extends StatefulWidget {
  const YUVDrawWidget({super.key});

  @override
  State<YUVDrawWidget> createState() => _YUVDrawWidgetState();
}

class _YUVDrawWidgetState extends State<YUVDrawWidget> {
  late final ui.Image yImage;
  late final ui.Image uImage;
  late final ui.Image vImage;
  bool imageLoaded = false;

  @override
  void initState() {
    super.initState();
    loadYuv();
  }

  Future<void> loadYuv() async {
    final yuvData = await rootBundle.load('assets/dash.yuv');
    const yLen = 1920 * 1080;
    const uvLen = 960 * 540;
    final yData = Uint8List.view(yuvData.buffer, 0, yLen);
    final uData = Uint8List.view(yuvData.buffer, yLen, uvLen);
    final vData = Uint8List.view(yuvData.buffer, yLen + uvLen, uvLen);
    final yRgbaData = Uint32List.fromList(yData);
    final uRgbaData = Uint32List.fromList(uData);
    final vRgbaData = Uint32List.fromList(vData);
    yImage = await decodeRawRgba(yRgbaData.buffer.asUint8List(), 1920, 1080);
    uImage = await decodeRawRgba(uRgbaData.buffer.asUint8List(), 960, 540);
    vImage = await decodeRawRgba(vRgbaData.buffer.asUint8List(), 960, 540);
    setState(() {
      imageLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return imageLoaded
        ? Yuvdraw(
            textureY: yImage,
            textureU: uImage,
            textureV: vImage,
          )
        : const SizedBox(width: 0);
  }
}

Future<ui.Image> decodeRawRgba(Uint8List bytes, int width, int height) {
  final completer = Completer<ui.Image>();
  decodeImageFromPixels(
    bytes.buffer.asUint8List(),
    width,
    height,
    PixelFormat.rgba8888,
    completer.complete,
  );
  return completer.future;
}
