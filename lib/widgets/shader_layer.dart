import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class ShaderLayer extends StatefulWidget {
  final bool isEnabled;
  final int mode; // 0: Onda, 1: Atomo
  final double frequency;
  final String shaderAsset;
  final Widget child;

  const ShaderLayer({
    super.key,
    required this.isEnabled,
    required this.mode,
    required this.frequency,
    required this.shaderAsset,
    required this.child,
  });

  @override
  State<ShaderLayer> createState() => _ShaderLayerState();
}

class _ShaderLayerState extends State<ShaderLayer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) {
      return widget.child;
    }

    return ShaderBuilder(
      (context, shader, child) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final elapsedTime = _animationController.value * 1000.0 * (widget.frequency / 6.0);

            return AnimatedSampler(
              (image, size, canvas) {
                // Uniforms order:
                // 0, 1: uSize (vec2)
                shader.setFloat(0, size.width);
                shader.setFloat(1, size.height);
                // 2: uTime (float)
                shader.setFloat(2, elapsedTime);
                // 3: uModo (float)
                shader.setFloat(3, widget.mode.toDouble());
                // Sampler 0: uTexture (sampler2D)
                shader.setImageSampler(0, image);

                final paint = Paint()..shader = shader;
                canvas.drawRect(Offset.zero & size, paint);
              },
              child: widget.child,
            );
          },
        );
      },
      assetKey: widget.shaderAsset,
      child: widget.child,
    );
  }
}
