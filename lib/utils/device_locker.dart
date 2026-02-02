import 'package:flutter/services.dart';

class DeviceLocker {
  static void lockDevice() {
    // Enable full screen immersion
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    // Disable back button and gestures
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Keep screen on
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }
}
