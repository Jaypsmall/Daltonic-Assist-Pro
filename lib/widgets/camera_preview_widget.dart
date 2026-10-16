import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPreviewWidget extends StatefulWidget {
  final Function(bool hasPermission) onPermissionResult;
  final Function(double zoomRatio) onZoomChange;

  const CameraPreviewWidget({
    super.key,
    required this.onPermissionResult,
    required this.onZoomChange,
  });

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isInitialized = false;
  double _minZoomLevel = 1.0;
  double _maxZoomLevel = 8.0;
  double _currentZoomLevel = 1.0;
  double _baseScale = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    // Check permission without blocking if already granted
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    
    final granted = status.isGranted;
    widget.onPermissionResult(granted);
    if (!granted) return;

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      // Using ResolutionPreset.medium ensures fast hardware warmup and surface allocation
      _controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }

      // Fetch zoom bounds in background so preview isn't delayed
      _fetchZoomLevels();
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _fetchZoomLevels() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      _minZoomLevel = await _controller!.getMinZoomLevel();
      final maxZoom = await _controller!.getMaxZoomLevel();
      _maxZoomLevel = maxZoom.clamp(1.0, 8.0);
    } catch (_) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
      setState(() {
        _isInitialized = false;
      });
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentZoomLevel;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final newZoom = (_baseScale * details.scale).clamp(_minZoomLevel, _maxZoomLevel);
    if ((newZoom - _currentZoomLevel).abs() > 0.01) {
      _currentZoomLevel = newZoom;
      await _controller!.setZoomLevel(newZoom);
      widget.onZoomChange(newZoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null || !_controller!.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC29B47)),
          ),
        ),
      );
    }

    return GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller!.value.previewSize?.height ?? MediaQuery.of(context).size.width,
            height: _controller!.value.previewSize?.width ?? MediaQuery.of(context).size.height,
            child: CameraPreview(_controller!),
          ),
        ),
      ),
    );
  }
}
