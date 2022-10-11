import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:umbra_flutter/umbra_flutter.dart';

/// {@template yuvdraw}
/// A Flutter Widget for the `yuvdraw` shader.
/// {@endtemplate}
class Yuvdraw extends UmbraWidget {
  /// {@macro yuvdraw}
  const Yuvdraw({
    super.key,
    super.blendMode = BlendMode.src,
    super.child,
    super.errorBuilder,
    super.compilingBuilder,
    required Image textureY,
    required Image textureU,
    required Image textureV,
  })  : _textureY = textureY,
        _textureU = textureU,
        _textureV = textureV,
        super();

  static Future<FragmentProgram>? _cachedProgram;

  final Image _textureY;

  final Image _textureU;

  final Image _textureV;

  @override
  List<double> getFloatUniforms() {
    return [];
  }

  @override
  List<ImageShader> getSamplerUniforms() {
    return [
      ImageShader(
        _textureY,
        TileMode.clamp,
        TileMode.clamp,
        UmbraShader.identity,
      ),
      ImageShader(
        _textureU,
        TileMode.clamp,
        TileMode.clamp,
        UmbraShader.identity,
      ),
      ImageShader(
        _textureV,
        TileMode.clamp,
        TileMode.clamp,
        UmbraShader.identity,
      ),
    ];
  }

  @override
  Future<FragmentProgram> program() {
    return _cachedProgram ??
        FragmentProgram.compile(
          spirv: Uint8List.fromList(base64Decode(_spirv)).buffer,
        );
  }
}

const _spirv =
    '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';
