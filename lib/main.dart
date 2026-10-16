import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/daltonic_profile.dart';
import 'theme/colors.dart';
import 'widgets/camera_preview_widget.dart';
import 'widgets/shader_layer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const DaltonicApp());
}

class DaltonicApp extends StatelessWidget {
  const DaltonicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DALTONIC ASSIST',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.techDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.techGold,
          surface: AppColors.techDark,
        ),
      ),
      home: const DaltonicMainScreen(),
    );
  }
}

class DaltonicMainScreen extends StatefulWidget {
  const DaltonicMainScreen({super.key});

  @override
  State<DaltonicMainScreen> createState() => _DaltonicMainScreenState();
}

class _DaltonicMainScreenState extends State<DaltonicMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // --- APP STATE ---
  bool _isEnglish = false;
  bool _hasCameraPermission = false;
  DaltonicProfile _activeProfile = DaltonicProfile.protanopia;
  double _frequency = 6.0;
  double _zoomRatio = 1.0;
  bool _isEnabled = true;
  int _activeEffectMode = 1; // 0: Onda, 1: Atomo

  @override
  Widget build(BuildContext context) {
    // Strings i18n
    final appTitle = "DALTONIC ASSIST";
    final visionModes = _isEnglish ? "VISION MODES" : "MODOS DE VISIÓN";
    final systemLabel = _isEnglish ? "SYSTEM" : "SISTEMA";
    final settingsLabel = _isEnglish ? "Interface Settings" : "Ajustes de Interfaz";
    final helpLabel = _isEnglish ? "Help Center" : "Centro de Ayuda";
    final shareLabel = _isEnglish ? "Share App" : "Compartir App";
    final languageLabel = _isEnglish ? "Cambiar a Español" : "Change to English";
    final effectModeLabel = _isEnglish ? "EFFECT MODE" : "MODO EFECTO";
    final isolateChannelLabel = _isEnglish ? "ISOLATE CHANNEL" : "AISLAR CANAL";
    final frequencyLabel = _isEnglish ? "QUANTUM FREQUENCY" : "FRECUENCIA CUÁNTICA";
    final createdByLabel = _isEnglish ? "Created by JAYLIZ with " : "Creado por JAYLIZ con ";

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        width: 300,
        backgroundColor: AppColors.techDark,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // --- CABECERA PREMIUM ---
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.techGold.withValues(alpha: 0.25),
                          AppColors.techDark,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.techGold, width: 2),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: Image.asset(
                              'assets/images/daltonic_assist_icon.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.visibility, color: AppColors.techGold, size: 36),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const GradientText(
                          "DALTONIC",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            letterSpacing: 1,
                          ),
                        ),
                        const Text(
                          "ASSIST PRO",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --- SECCIONES DE MODOS DE VISIÓN ---
                  _buildMenuLabel(visionModes),
                  ...DaltonicProfile.values.map((profile) {
                    final isSelected = _activeProfile == profile;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.techGold.withValues(alpha: 0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          profile.icon,
                          color: isSelected ? AppColors.techGold : Colors.grey,
                        ),
                        title: isSelected
                            ? GradientText(
                                profile.getDisplayName(_isEnglish),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              )
                            : Text(
                                profile.getDisplayName(_isEnglish),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                        subtitle: Text(
                          profile.getDetail(_isEnglish),
                          style: const TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        onTap: () {
                          setState(() {
                            _activeProfile = profile;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  // --- SECCIÓN SISTEMA ---
                  _buildMenuLabel(systemLabel),
                  _buildDrawerItem(
                    icon: Icons.language,
                    label: languageLabel,
                    onTap: () {
                      setState(() {
                        _isEnglish = !_isEnglish;
                      });
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings,
                    label: settingsLabel,
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_outline,
                    label: helpLabel,
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.share,
                    label: shareLabel,
                    onTap: () {},
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            // --- FOOTER DEL MENU ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  Divider(color: AppColors.techGold.withValues(alpha: 0.2), thickness: 1),
                  const SizedBox(height: 12),
                  const GradientText(
                    "DaltonicAssist v1.0.2",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        createdByLabel,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
                      ),
                      const Text(
                        "❤️",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // --- CAMERA PREVIEW + SHADER LAYER ---
          Positioned.fill(
            child: ShaderLayer(
              isEnabled: _isEnabled && _hasCameraPermission,
              mode: _activeEffectMode,
              frequency: _frequency,
              shaderAsset: _activeProfile.shaderAsset,
              child: CameraPreviewWidget(
                onPermissionResult: (granted) {
                  if (_hasCameraPermission != granted) {
                    setState(() {
                      _hasCameraPermission = granted;
                    });
                  }
                },
                onZoomChange: (zoom) {
                  setState(() {
                    _zoomRatio = zoom;
                  });
                },
              ),
            ),
          ),

          // --- BARRA SUPERIOR PROFESIONAL ---
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: AppColors.techGold, size: 32),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                    const SizedBox(width: 8),
                    GradientText(
                      appTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- BOTÓN MASTER FLOTANTE (ESTILO ORO) ---
          Positioned(
            right: 24,
            top: MediaQuery.of(context).size.height / 2 - 32,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isEnabled = !_isEnabled;
                });
              },
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _isEnabled
                      ? const LinearGradient(
                          colors: [AppColors.techGoldDark, AppColors.techGoldLight, AppColors.techGold],
                        )
                      : LinearGradient(
                          colors: [Colors.grey.shade800, Colors.grey.shade600, Colors.grey.shade800],
                        ),
                  border: Border.all(
                    color: _isEnabled ? AppColors.techGoldLight : Colors.grey,
                    width: 2,
                  ),
                  boxShadow: _isEnabled
                      ? [
                          BoxShadow(
                            color: AppColors.techGold.withValues(alpha: 0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          )
                        ]
                      : [],
                ),
                child: Icon(
                  _isEnabled ? Icons.power_settings_new : Icons.power_off,
                  color: _isEnabled ? Colors.white : Colors.grey,
                  size: 30,
                ),
              ),
            ),
          ),

          // --- PANEL DE CONTROL INFERIOR (REFINADO) ---
          Positioned(
            left: 20,
            bottom: 40,
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.techGold.withValues(alpha: 0.2), width: 1),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHudSection(
                        title: effectModeLabel,
                        child: Row(
                          children: [
                            _buildModeIconSmall("〰️", _activeEffectMode == 0, () {
                              setState(() {
                                _activeEffectMode = 0;
                              });
                            }),
                            const SizedBox(width: 8),
                            _buildModeIconSmall("░", _activeEffectMode == 1, () {
                              setState(() {
                                _activeEffectMode = 1;
                              });
                            }),
                          ],
                        ),
                      ),
                      _buildHudSection(
                        title: isolateChannelLabel,
                        child: Row(
                          children: [
                            _buildLetterCircle("R", AppColors.techRed, _activeProfile == DaltonicProfile.protanopia, () {
                              setState(() {
                                _activeProfile = DaltonicProfile.protanopia;
                              });
                            }),
                            const SizedBox(width: 8),
                            _buildLetterCircle("G", AppColors.techGreen, _activeProfile == DaltonicProfile.deuteranopia, () {
                              setState(() {
                                _activeProfile = DaltonicProfile.deuteranopia;
                              });
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildHudSection(
                    title: frequencyLabel,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.techGold,
                            inactiveTrackColor: Colors.grey.shade800,
                            thumbColor: AppColors.techGold,
                            overlayColor: AppColors.techGold.withValues(alpha: 0.2),
                            trackHeight: 3,
                          ),
                          child: Slider(
                            value: _frequency,
                            min: 0.5,
                            max: 12.0,
                            onChanged: (val) {
                              setState(() {
                                _frequency = val;
                              });
                            },
                          ),
                        ),
                        GradientText(
                          "${_frequency.toStringAsFixed(1)} Hz",
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- INDICADOR DE ZOOM ---
          if (_zoomRatio > 1.05)
            Positioned(
              left: 0,
              right: 0,
              bottom: 240,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Text(
                    "${_zoomRatio.toStringAsFixed(1)} x",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 16, bottom: 8),
      child: GradientText(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.techGold.withValues(alpha: 0.5)),
      title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  Widget _buildHudSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          title,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildModeIconSmall(String iconStr, bool selected, VoidCallback onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? AppColors.techGold.withValues(alpha: 0.35) : Colors.black.withValues(alpha: 0.6),
          border: Border.all(
            color: selected ? AppColors.techGold : Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            iconStr,
            style: TextStyle(
              color: selected ? AppColors.techGold : Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLetterCircle(String letter, Color color, bool isSelected, VoidCallback onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: isSelected ? 3 : 0,
          ),
        ),
        child: Center(
          child: Text(
            letter,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
