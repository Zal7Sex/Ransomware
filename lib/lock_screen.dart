import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'utils/audio_player.dart';
// import 'package:window_manager/window_manager.dart'; // Opsional

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _showError = false;
  bool _isPlaying = false;
  bool _isVibrating = false;

  @override
  void initState() {
    super.initState();
    _initializeLock();
    
    // Opsional: Untuk mencegah close dengan back button
    SystemChannels.platform.setMethodCallHandler((call) async {
      if (call.method == 'SystemNavigator.pop') {
        // Getarkan saat mencoba keluar
        final hasVibrator = await Vibration.hasVibrator() ?? false;
        if (hasVibrator) {
          Vibration.vibrate(duration: 300);
        }
        return null;
      }
      return null;
    });
  }

  Future<void> _initializeLock() async {
    // FULLSCREEN & LOCK ORIENTATION
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Opsional: Window Manager untuk overlay lebih kuat
    // try {
    //   await windowManager.ensureInitialized();
    //   await windowManager.setFullScreen(true);
    //   await windowManager.setAlwaysOnTop(true);
    //   await windowManager.setAsFrameless();
    // } catch (e) {
    //   print('Window manager error: $e');
    // }

    // Play sound
    await AudioUtil.playHackedSound();
    _isPlaying = true;

    // Vibrate
    _vibrateDevice();
  }

  Future<void> _vibrateDevice() async {
    if (_isVibrating) return;
    
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      _isVibrating = true;
      Vibration.vibrate(duration: 1000);
      await Future.delayed(const Duration(seconds: 2));
      _isVibrating = false;
    }
  }

  Future<void> _checkPin() async {
    if (_pinController.text == '969') {
      await AudioUtil.stopAudio();
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemNavigator.pop();
    } else {
      setState(() => _showError = true);
      _pinController.clear();
      
      final hasVibrator = await Vibration.hasVibrator() ?? false;
      if (hasVibrator) {
        Vibration.vibrate(pattern: [0, 200, 100, 500]);
      }
      
      await AudioUtil.stopAudio();
      await Future.delayed(const Duration(milliseconds: 300));
      await AudioUtil.playHackedSound();
    }
  }

  // ... (sisanya sama seperti sebelumnya)
