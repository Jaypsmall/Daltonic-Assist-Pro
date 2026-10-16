import 'package:flutter/material.dart';

class AppColors {
  static const Color techDark = Color(0xFF050505);
  static const Color techBlue = Color(0xFF00C2FF);
  static const Color techCyan = Color(0xFF00FFE0);
  static const Color techGreen = Color(0xFF00FF47);
  static const Color techRed = Color(0xFFFF003D);
  static const Color techOrange = Color(0xFFFF8A00);
  static const Color techYellow = Color(0xFFFFE600);
  static const Color techGold = Color(0xFFC29B47);
  static const Color techGoldLight = Color(0xFFFFF3A8);
  static const Color techGoldDark = Color(0xFF8C6221);

  static const Gradient goldGradient = LinearGradient(
    colors: [techGoldDark, techGoldLight, techGold],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;

  const GradientText(
    this.text, {
    super.key,
    this.style,
    this.gradient = AppColors.goldGradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
