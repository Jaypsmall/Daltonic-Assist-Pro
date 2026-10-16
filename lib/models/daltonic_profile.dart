import 'package:flutter/material.dart';

enum DaltonicProfile {
  protanopia(
    shaderAsset: 'shaders/protanopia.frag',
    displayNameEs: 'Protanopia',
    displayNameEn: 'Protanopia',
    icon: Icons.visibility,
    detailEs: 'Asistencia para Rojos',
    detailEn: 'Red Assistance',
  ),
  deuteranopia(
    shaderAsset: 'shaders/deuteranopia.frag',
    displayNameEs: 'Deuteranopia',
    displayNameEn: 'Deuteranopia',
    icon: Icons.visibility,
    detailEs: 'Asistencia para Verdes',
    detailEn: 'Green Assistance',
  );

  final String shaderAsset;
  final String displayNameEs;
  final String displayNameEn;
  final IconData icon;
  final String detailEs;
  final String detailEn;

  const DaltonicProfile({
    required this.shaderAsset,
    required this.displayNameEs,
    required this.displayNameEn,
    required this.icon,
    required this.detailEs,
    required this.detailEn,
  });

  String getDisplayName(bool isEnglish) => isEnglish ? displayNameEn : displayNameEs;
  String getDetail(bool isEnglish) => isEnglish ? detailEn : detailEs;
}
